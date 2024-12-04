class CodeExecutionResult {
  final String? runTime;
  final String? statusMessage;
  final CodeExecutionResultState state;
  final List<String>? codeAnswers; // Initialize here
  final List<String>? codePrintOutputs; // Initialize here
  final List<String>? expectedCodeAnswer; // Initialize here

  CodeExecutionResult({
    required this.runTime,
    required this.statusMessage,
    this.state = CodeExecutionResultState.pending,
    this.codeAnswers,
    this.codePrintOutputs,
    this.expectedCodeAnswer,
  });
}

enum CodeExecutionResultState { pending, started, success, failed }
