import 'package:bloc/bloc.dart';
import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/features/question/data/parser/leetcode_solution_parser.dart';
import 'package:codersgym/features/question/domain/model/solution.dart';
import 'package:codersgym/features/question/domain/repository/question_repository.dart';

typedef QuestionSolutionState = ApiState<Solution, Exception>;

class QuestionSolutionCubit extends Cubit<QuestionSolutionState> {
  final QuestionRepository _questionRepository;
  final HTMLMarkdownParser _htmlMarkdownParser;
  QuestionSolutionCubit(
    this._questionRepository,
    this._htmlMarkdownParser,
  ) : super(ApiState.initial());

  Future<void> getQuestionSolution(String questionTitleSlug) async {
    if (state is ApiLoaded) return; // Prevents calling api again
    emit(ApiLoading());
    final result =
        await _questionRepository.getOfficialSolution(questionTitleSlug);
    if (result.isFailure) {
      emit(ApiError(result.getFailureException));
      return;
    }
    final solution = result.getSuccessValue;
    if (solution == null || (solution.content?.isEmpty ?? true)) {
      emit(ApiError(Exception('Solution not found')));
      return;
    }
    final parsedContentResult =
        _htmlMarkdownParser.parseAndFormatContent(solution.content ?? '');
    if (parsedContentResult.isFailure) {
      emit(ApiError(parsedContentResult.getFailureException));
      return;
    }
    final parsedContent = parsedContentResult.getSuccessValue;
    emit(ApiLoaded(solution.copyWith(content: parsedContent)));
  }
}
