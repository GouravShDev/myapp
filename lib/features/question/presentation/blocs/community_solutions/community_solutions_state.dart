part of 'community_solutions_bloc.dart';

class CommunitySolutionsState extends Equatable {
  final List<CommunitySolutionPostDetail> solutions;
  final bool isLoading;
  final Exception? error;
  final bool moreSolutionsAvailable;
  const CommunitySolutionsState({
    required this.solutions,
    required this.isLoading,
    required this.error,
    required this.moreSolutionsAvailable,
  });

  factory CommunitySolutionsState.initial() {
    return const CommunitySolutionsState(
      solutions: [],
      isLoading: false,
      error: null,
      moreSolutionsAvailable: true,
    );
  }
  CommunitySolutionsState copyWith({
    List<CommunitySolutionPostDetail>? questions,
    bool? isLoading,
    Exception? error,
    bool? moreQuestionAvailable,
  }) {
    return CommunitySolutionsState(
      solutions: questions ?? this.solutions,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      moreSolutionsAvailable:
          moreQuestionAvailable ?? this.moreSolutionsAvailable,
    );
  }

  @override
  List<Object?> get props =>
      [solutions, isLoading, error, moreSolutionsAvailable];
}
