import 'package:codersgym/core/api/leetcode_api.dart';
import 'package:codersgym/features/code_editor/domain/repository/code_editor_repository.dart';

class CodeEditorRepositoryImp implements CodeEditorRepository {
  final LeetcodeApi leetcodeApi;

  CodeEditorRepositoryImp({required this.leetcodeApi});
  @override
  Future<void> runCode({
    required String questionTitleSlug,
    required String questionId,
    required String programmingLanguage,
    required String code,
    required String testCases,
  })async {
   await leetcodeApi.runCode(
      questionTitleSlug: questionTitleSlug,
      questionId: questionId,
      programmingLanguage: programmingLanguage,
      code: code,
      testCases: testCases,
    );
  }
}
