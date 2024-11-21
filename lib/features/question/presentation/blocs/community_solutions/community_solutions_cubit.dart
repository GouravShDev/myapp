import 'package:bloc/bloc.dart';
import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/features/question/domain/model/community_solution_post_detail.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/domain/repository/question_repository.dart';

typedef CommunitySolutionsState
    = ApiState<List<CommunitySolutionPostDetail>, Exception>;

class CommunitySolutionsCubit extends Cubit<CommunitySolutionsState> {
  final QuestionRepository _questionRepository;
  CommunitySolutionsCubit(this._questionRepository) : super(ApiState.initial());

  int currentSkip = 0;
  int currentLimit = 10;
  Future<void> getCommunitySolutions(
    Question quesiton,
  ) async {
    emit(ApiLoading());
    final result = await _questionRepository.getCommunitySolutions(
      quesiton.titleSlug ?? '',
      "HOT", // Temporary passing "HOT" as default until filter are implemented
    );
    result.when(
      onSuccess: (communityPosts) {
        emit(ApiLoaded(communityPosts));
      },
      onFailure: (exception) {
        emit(ApiError(exception));
      },
    );
  }
}
