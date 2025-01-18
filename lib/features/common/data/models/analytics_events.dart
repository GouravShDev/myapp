abstract class AnalyticsEvents {
  // Question Related Events
  static const String viewQuestion = 'view_question';
  static const String viewQuestionSheet = 'view_question_sheet';
  static const String startSolvingQuestion = 'start_solving_question';
  static const String viewSolution = 'view_solution';
  static const String copyCode = 'copy_code';
  static const String resetCode = 'reset_code';
  static const String formatCode = 'format_code';
  static const String runCode = 'run_code';
  static const String bookmarkQuestion = 'bookmark_question';
  static const String shareQuestion = 'share_question';
  static const String addTestCase = 'test_case_added';
  static const String removeTestCase = 'test_case_removed';
  static const String updateTestCase = 'test_case_updated';

  static const String changeProgrammingLanguage = 'change_programming_language';

  // Question Parameters
  static const String questionId = 'question_id';
  static const String questionTitle = 'question_title';
  static const String questionDifficulty = 'difficulty';
  static const String questionCategory = 'category'; // e.g., arrays, dp, trees
  static const String programmingLanguage = 'programming_language';
  static const String timeSpent = 'time_spent';
  static const String solutionStatus =
      'solution_status'; // accepted, wrong_answer, tle
  static const String executionTime = 'execution_time';
  static const String memoryUsed = 'memory_used';

  // Learning Path Parameters
  static const String pathId = 'path_id';
  static const String pathName = 'path_name';
  static const String pathProgress = 'progress_percentage';

  // Practice Session Events
  static const String startPracticeSession = 'start_practice_session';
  static const String endPracticeSession = 'end_practice_session';
  static const String pausePracticeSession = 'pause_practice_session';
  static const String resumePracticeSession = 'resume_practice_session';

  // Practice Parameters
  static const String sessionDuration = 'session_duration';
  static const String questionsAttempted = 'questions_attempted';
  static const String questionsCompleted = 'questions_completed';
  static const String sessionType = 'session_type'; // daily, contest, custom

  // User Progress Events
  static const String achieveBadge = 'achieve_badge';
  static const String levelUp = 'level_up';
  static const String streakUpdate = 'streak_update';
  static const String unlockAchievement = 'unlock_achievement';

  // Progress Parameters
  static const String badgeId = 'badge_id';
  static const String badgeName = 'badge_name';
  static const String currentLevel = 'current_level';
  static const String streakDays = 'streak_days';
  static const String achievementId = 'achievement_id';

  // Social Events
  static const String viewProfile = 'view_profile';
  static const String shareSolution = 'share_solution';
  static const String commentOnSolution = 'comment_on_solution';

  // Performance Events
  static const String appCrash = 'app_crash';
  static const String compilerError = 'compiler_error';
  static const String ideLoadTime = 'ide_load_time';
  static const String questionLoadTime = 'question_load_time';

  // Feature Usage Events
  static const String useCodeCompletion = 'use_code_completion';
  static const String useDebugger = 'use_debugger';
  static const String useHints = 'use_hints';
  static const String useTemplateCode = 'use_template_code';
  static const String changeTheme = 'change_theme';
  static const String changeFontSize = 'change_font_size';

  // Search Events
  static const String searchQuestion = 'search_question';
  static const String applySearchFilter = 'apply_search_filter';
  static const String clearSearchFilter = 'clear_search_filter';

  // Search Parameters
  static const String searchQuery = 'search_query';
  static const String filterType = 'filter_type';
  static const String searchResultCount = 'result_count';
}
