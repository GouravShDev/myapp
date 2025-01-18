part of 'code_editor_bloc.dart';

sealed class CodeEditorEvent extends Equatable {
  const CodeEditorEvent();

  @override
  List<Object> get props => [];
}

class CodeEditorCodeLoadConfig extends CodeEditorEvent {
  final Question question;
  const CodeEditorCodeLoadConfig(this.question);

  @override
  List<Object> get props => [question];
}

class CodeEditorCodeUpdateEvent extends CodeEditorEvent {
  final String updatedCode;

  const CodeEditorCodeUpdateEvent({
    required this.updatedCode,
  });
  @override
  List<Object> get props => [updatedCode];
}

class CodeEditorRunCodeEvent extends CodeEditorEvent with TrackAnalytic {
  final Question question;

  const CodeEditorRunCodeEvent({
    required this.question,
  });
  @override
  String get eventName => AnalyticsEvents.runCode;

  @override
  Map<String, Object> get properties => question.toAnalyticsMap();
}

class CodeEditorSubmitCodeEvent extends CodeEditorEvent with TrackAnalytic {
  final Question question;

  const CodeEditorSubmitCodeEvent({
    required this.question,
  });
  @override
  List<Object> get props => [question];

  @override
  String get eventName => AnalyticsEvents.questionsAttempted;

  @override
  Map<String, Object> get properties => question.toAnalyticsMap();
}

class CodeEditorRunCodeResultUpdateEvent extends CodeEditorEvent {
  final CodeExecutionState executionResult;

  const CodeEditorRunCodeResultUpdateEvent({
    required this.executionResult,
  });
  @override
  List<Object> get props => [executionResult];
}

class CodeEditorSubmitCodeResultUpdateEvent extends CodeEditorEvent {
  final CodeExecutionState executionResult;

  const CodeEditorSubmitCodeResultUpdateEvent({
    required this.executionResult,
  });
  @override
  List<Object> get props => [executionResult];
}

class CodeEditorLanguageUpdateEvent extends CodeEditorEvent with TrackAnalytic {
  final ProgrammingLanguage language;
  final Question question;

  const CodeEditorLanguageUpdateEvent({
    required this.language,
    required this.question,
  });

  @override
  List<Object> get props => [language, question];

  @override
  String get eventName => AnalyticsEvents.programmingLanguage;
}

class CodeEditorResetCodeEvent extends CodeEditorEvent with TrackAnalytic {
  @override
  String get eventName => AnalyticsEvents.resetCode;
}

class CodeEditorFormatCodeEvent extends CodeEditorEvent with TrackAnalytic {
  @override
  String get eventName => AnalyticsEvents.formatCode;
}

class CodeEditorUpdateTestcaseEvent extends CodeEditorEvent with TrackAnalytic {
  final List<TestCase> testcases;

  const CodeEditorUpdateTestcaseEvent({
    required this.testcases,
  });

  @override
  List<Object> get props => [testcases];

  @override
  String get eventName => AnalyticsEvents.updateTestCase;
}
