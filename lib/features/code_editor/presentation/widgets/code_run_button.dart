import 'package:codersgym/features/code_editor/presentation/blocs/code_editor/code_editor_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CodeRunButton extends StatelessWidget {
  const CodeRunButton({
    super.key,
    required this.runCode,
  });

  final Null Function() runCode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CodeEditorBloc, CodeEditorState>(
      builder: (context, state) {
        final isRunning = state.executionState == CodeExecutionPending();

        return Stack(
          alignment: Alignment.center,
          children: [
            Visibility(
              visible: (isRunning),
              child: const CircularProgressIndicator(),
            ),
            Visibility(
              maintainAnimation: true,
              maintainState: true,
              maintainSize: true,
              visible: !isRunning,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: runCode,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Run Code'),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
