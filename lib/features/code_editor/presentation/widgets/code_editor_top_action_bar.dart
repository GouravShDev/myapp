import 'dart:math';

import 'package:codersgym/features/code_editor/presentation/blocs/code_editor/code_editor_bloc.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/question_description_bottomsheet.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';

class CodeEditorTopActionBar extends StatelessWidget {
  const CodeEditorTopActionBar({
    super.key,
    required this.onToggleFullScreen,
    required this.question,
    required this.isFullScreen,
    required this.codeController,
  });
  final VoidCallback onToggleFullScreen;
  final Question question;
  final bool isFullScreen;
  final CodeController codeController;

  void showProblemDescriptionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => QuestionDescriptionBottomsheet(
        question: question,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final codeEditorBloc = context.read<CodeEditorBloc>();
    final iconStyle = IconButton.styleFrom(
      backgroundColor: Colors.grey[850],
      padding: EdgeInsets.all(
        8,
      ),
    );
    return Row(
      children: [
        IconButton(
          onPressed: () => showProblemDescriptionBottomSheet(context),
          icon: Icon(Icons.description_outlined),
          style: iconStyle,
        ),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () {
            Clipboard.setData(
              ClipboardData(text: codeController.text),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Code copied to clipboard')),
            );
          },
          style: iconStyle,
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.format_align_left),
          style: iconStyle,
        ),
        IconButton(
          onPressed: () {
          },
          icon: Transform(
            transform: Matrix4.identity()..rotateY(pi), // Flips horizontally
            alignment: Alignment.center,
            child: Icon(
              Icons.refresh_rounded,
            ),
          ),
          style: iconStyle,
        ),
        IconButton(
          onPressed: onToggleFullScreen,
          icon: !isFullScreen
              ? Icon(Icons.fullscreen_outlined)
              : Icon(Icons.fullscreen_exit_outlined),
          style: iconStyle,
        ),
        Spacer(),
        BlocBuilder<CodeEditorBloc, CodeEditorState>(
          builder: (context, state) {
            final isRunning =
                state.codeSubmissionState == CodeExecutionPending();

            return Stack(
              alignment: Alignment.center,
              children: [
                Visibility(
                  visible: (isRunning),
                  child: CircularProgressIndicator(),
                ),
                Visibility(
                  maintainAnimation: true,
                  maintainState: true,
                  maintainSize: true,
                  visible: !isRunning,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.0,
                        vertical: 4.0,
                      ),
                    ),
                    icon: Icon(Icons.upload_file_outlined),
                    onPressed: () {
                      codeEditorBloc.add(
                        CodeEditorSubmitCodeEvent(question: question),
                      );
                    },
                    label: const Text('Submit'),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
