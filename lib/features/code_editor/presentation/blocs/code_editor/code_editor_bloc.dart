import 'package:bloc/bloc.dart';
import 'package:codersgym/features/code_editor/domain/model/programming_language.dart';
import 'package:codersgym/features/code_editor/domain/repository/code_editor_repository.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:equatable/equatable.dart';

part 'code_editor_event.dart';
part 'code_editor_state.dart';

class CodeEditorBloc extends Bloc<CodeEditorEvent, CodeEditorState> {
  final CodeEditorRepository _codeEdtiorRepository;
  CodeEditorBloc(this._codeEdtiorRepository)
      : super(CodeEditorState.initial()) {
    on<CodeEditorEvent>((event, emit) async {
      switch (event) {
        case CodeEditorRunCodeEvent():
          _onCodeEditorRunCodeEvent(event, emit);
          break;
      }
    });
  }
  _onCodeEditorRunCodeEvent(
    CodeEditorRunCodeEvent event,
    Emitter<CodeEditorState> emit,
  ) async {
    emit(state.copyWith(executionState: CodeExecutionPending()));
    await _codeEdtiorRepository.runCode(
      questionTitleSlug: event.question.titleSlug ?? "",
      questionId: event.question.frontendQuestionId ?? '0',
      programmingLanguage: ProgrammingLanguage.cpp.name,
      code: state.code,
      testCases: 'testCases',
    );

    emit(state.copyWith(executionState: CodeExecutionSuccess()));
  }
}
