part of 'community_solutions_bloc.dart';

sealed class CommunitySolutionsEvent extends Equatable {
  const CommunitySolutionsEvent();
}

class FetchCommunitySolutionListEvent extends CommunitySolutionsEvent {
  /// Pass skip : 0 for reseting the list to start from the begining
  /// otherwise it add the search result in the current list only
  final int? skip;
  final int? limit;
  final String questionTitleSlug;

  const FetchCommunitySolutionListEvent({
    this.limit,
    this.skip,
  required this.questionTitleSlug,
  });

  @override
  List<Object?> get props => [skip, limit, questionTitleSlug];
}
