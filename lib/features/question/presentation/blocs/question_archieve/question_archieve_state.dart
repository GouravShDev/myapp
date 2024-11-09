part of 'question_archieve_bloc.dart';

class QuestionArchieveState extends Equatable {
  final List<Question> questions;
  final bool isLoading;
  final Exception? error;
  final bool moreQuestionAvailable;
  const QuestionArchieveState({
    required this.questions,
    required this.isLoading,
    required this.error,
    required this.moreQuestionAvailable,
  });

  factory QuestionArchieveState.initial() {
    return const QuestionArchieveState(
      questions: [],
      isLoading: false,
      error: null,
      moreQuestionAvailable: true,
    );
  }
  QuestionArchieveState copyWith({
    List<Question>? questions,
    bool? isLoading,
    Exception? error,
    bool? moreQuestionAvailable,
  }) {
    return QuestionArchieveState(
      questions: questions ?? this.questions,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      moreQuestionAvailable:
          moreQuestionAvailable ?? this.moreQuestionAvailable,
    );
  }

  @override
  List<Object?> get props =>
      [questions, isLoading, error, moreQuestionAvailable];
}