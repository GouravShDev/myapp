part of 'question_filter_cubit.dart';

class QuestionFilterState extends Equatable {
  final ProblemSortOption? sortOption;
  final String? difficulty;
  final Set<TopicTags>? topicTags;

  const QuestionFilterState({
    this.sortOption,
    this.difficulty,
    this.topicTags,
  });

  QuestionFilterState copyWith({
    ProblemSortOption? sortOption,
    String? difficulty,
    Set<TopicTags>? topicTags,
  }) {
    return QuestionFilterState(
      sortOption: sortOption ?? this.sortOption,
      difficulty: difficulty ?? this.difficulty,
      topicTags: topicTags ?? this.topicTags,
    );
  }

  @override
  List<Object?> get props => [sortOption, difficulty, topicTags];
}
