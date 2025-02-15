import 'package:codersgym/core/theme/app_theme.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:flutter/material.dart';

class QuestionStatusIcon extends StatelessWidget {
  const QuestionStatusIcon({
    super.key,
    required this.status,
  });
  final QuestionStatus status;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          getStatusText(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).hintColor,
          ),
        ),
        const SizedBox(width: 8), // Add spacing between icon and text
        Icon(
          getStatusIcon(),
          size: 14,
          color: getStatusColor(context),
        ),
      ],
    );
  }

  IconData? getStatusIcon() {
    return switch (status) {
      QuestionStatus.accepted => Icons.check_circle_outlined,
      QuestionStatus.notAccepted => Icons.incomplete_circle,
      _ => null,
    };
  }

  Color getStatusColor(BuildContext context) {
    final theme = Theme.of(context);
    return switch (status) {
      QuestionStatus.accepted => theme.colorScheme.successColor,
      QuestionStatus.notAccepted => theme.primaryColor,
      _ => theme.hintColor,
    };
  }

  String getStatusText() {
    return switch (status) {
      QuestionStatus.accepted => 'Solved',
      QuestionStatus.notAccepted => 'Attempted',
      _ => '',
    };
  }

}
