import 'package:codersgym/features/common/widgets/loading_dots.dart';
import 'package:flutter/material.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/presentation/widgets/question_difficulty_text.dart';

class DailyQuestionCard extends StatelessWidget {
  const DailyQuestionCard({
    super.key,
    required this.question,
    required this.onSolveTapped,
    this.isFetching = false,
  });

  final Question question;
  final VoidCallback onSolveTapped;
  final bool isFetching;

  factory DailyQuestionCard.empty() {
    return DailyQuestionCard(
      question: const Question(
        title: 'two sum',
        difficulty: 'easy',
      ),
      onSolveTapped: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ("${question.frontendQuestionId}. ") +
                      (question.title ?? "No Title"),
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    QuestionDifficultyText(question),
                    ElevatedButton(
                      onPressed: onSolveTapped,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: isFetching
                            ? Theme.of(context).primaryColor.withOpacity(0.7)
                            : null,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: isFetching
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text("Loading"),
                                  const SizedBox(width: 8),
                                  LoadingDots(),
                                ],
                              )
                            : const Text("Solve"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
