import 'package:bloc/bloc.dart';
import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/features/question/data/parser/leetcode_solution_parser.dart';
import 'package:codersgym/features/question/domain/model/community_solution_post_detail.dart';
import 'package:codersgym/features/question/domain/repository/question_repository.dart';

typedef CommunityPostDetailState
    = ApiState<CommunitySolutionPostDetail, Exception>;

class CommunityPostDetailCubit extends Cubit<CommunityPostDetailState> {
  final QuestionRepository _questionRepository;
  CommunityPostDetailCubit(
    this._questionRepository,
  ) : super(ApiState.initial());

  Future<void> getCommunitySolutionsDetails(
    CommunitySolutionPostDetail post,
  ) async {
    emit(ApiLoading());
    final result = await _questionRepository.getCommunitySolutionDetails(
      post.id ?? 0,
    );
    if (result.isFailure) {
      emit(ApiError(result.getFailureException));
      return;
    }
    final solutionDetail = result.getSuccessValue;

    final parsedContentResult =
        solutionDetail.post?.content?.replaceAll(r'\n', '\n');

    emit(
      ApiLoaded(
        solutionDetail.copyWith(
          post: solutionDetail.post?.copyWith(
            content: parsedContentResult,
          ),
        ),
      ),
    );
  }
}
