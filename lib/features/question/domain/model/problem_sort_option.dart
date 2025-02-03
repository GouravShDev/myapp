enum ProblemSortOption {
  titleAsc,
  titleDesc,
  acceptanceRateAsc,
  acceptanceRateDesc,
  difficultyAsc,
  difficultyDesc;

  String get displayValue {
    switch (this) {
      case ProblemSortOption.titleAsc:
        return 'ABC ▲';
      case ProblemSortOption.titleDesc:
        return 'ABC ▼';
      case ProblemSortOption.acceptanceRateAsc:
        return 'AC ▲';
      case ProblemSortOption.acceptanceRateDesc:
        return 'AC ▼';
      case ProblemSortOption.difficultyAsc:
        return 'DF ▲';
      case ProblemSortOption.difficultyDesc:
        return 'DF ▼';
    }
  }

  String get orderBy {
    switch (this) {
      case ProblemSortOption.titleAsc:
      case ProblemSortOption.titleDesc:
        return "FRONTEND_ID";
      case ProblemSortOption.acceptanceRateAsc:
      case ProblemSortOption.acceptanceRateDesc:
        return "AC_RATE";
      case ProblemSortOption.difficultyAsc:
      case ProblemSortOption.difficultyDesc:
        return "DIFFICULTY";
    }
  }

  String get sortOrder {
    switch (this) {
      case ProblemSortOption.titleAsc:
      case ProblemSortOption.acceptanceRateAsc:
      case ProblemSortOption.difficultyAsc:
        return "ASCENDING";
      case ProblemSortOption.titleDesc:
      case ProblemSortOption.acceptanceRateDesc:
      case ProblemSortOption.difficultyDesc:
        return "DESCENDING";
    }
  }
}
