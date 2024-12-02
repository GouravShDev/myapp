part of 'code_editor_bloc.dart';

sealed class CodeEditorEvent extends Equatable {
  const CodeEditorEvent();

  @override
  List<Object> get props => [];
}

class CodeEditorRunCodeEvent extends CodeEditorEvent {
  final Question question;

  const CodeEditorRunCodeEvent({
    required this.question,
  });
}
