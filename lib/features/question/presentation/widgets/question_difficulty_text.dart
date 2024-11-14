import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:codersgym/features/question/domain/model/question.dart';

class QuestionDifficultyText extends HookWidget {
  const QuestionDifficultyText(
    this.question, {
      this.showLabel = true,
    super.key,
  });
  final Question question;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final isDifficultyVisible = useState(false);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Row(
      children: [
    if(showLabel)    Text(
          "Difficulty: \t",
          style: textTheme.bodyMedium?.copyWith(color: theme.hintColor),
        ),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Opacity(
              opacity: isDifficultyVisible.value ? 1.0 : 0.0,
              child: Text(
                question.difficulty ?? "N/A",
                style: textTheme.bodyMedium?.copyWith(
                  color:
                      getColorFromDifficulty(question.difficulty ?? "Unknown"),
                ),
              ),
            ),
            Opacity(
              opacity: isDifficultyVisible.value ? 0.0 : 1.0,
              child: Text(
                "•••••••",
                style: textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                ),
              ),
            ),
          ],
        ),
        IconButton(
          icon: Icon(
            isDifficultyVisible.value ? Icons.visibility_off : Icons.visibility,
            color: theme.hintColor,
          ),
          onPressed: () {
            isDifficultyVisible.value = !isDifficultyVisible.value;
          },
        ),
      ],
    );
  }
}

getColorFromDifficulty(String difficulty) {
  return switch (difficulty) {
    "Easy" => Colors.green,
    "Medium" => Colors.amber,
    "Hard" => Colors.red,
    _ => Colors.grey,
  };
}
