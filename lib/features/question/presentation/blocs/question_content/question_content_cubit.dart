import 'package:bloc/bloc.dart';
import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/domain/repository/question_repository.dart';

typedef QuestionContentState = ApiState<Question, Exception>;

class QuestionContentCubit extends Cubit<ApiState<Question, Exception>> {
  QuestionContentCubit(this._questionRepository) : super(ApiState.initial());
  final QuestionRepository _questionRepository;
  Future<void> getQuestionContent(Question question) async {
    if (question.titleSlug == null) {
      emit(ApiError(Exception('Question Title is null')));
      return;
    }
    emit(ApiLoading());
    final result =
        await _questionRepository.getQuestionContent(question.titleSlug!);
    result.when(
      onSuccess: (content) {
        emit(ApiLoaded(content));
      },
      onFailure: (exception) {
        emit(ApiError(exception));
      },
    );
  }
}
