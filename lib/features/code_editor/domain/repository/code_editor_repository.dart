abstract interface class CodeEditorRepository {
  Future<void> runCode({
    required String questionTitleSlug,
    required String questionId,
    required String programmingLanguage,
    required String code,
    required String testCases,
  });
}
