import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/presentation/widgets/question_difficulty_text.dart';

class DailyQuestionCard extends StatelessWidget {
  const DailyQuestionCard({
    super.key,
    required this.question,
    required this.onSolveTapped,
  });

  final Question question;
  final VoidCallback onSolveTapped;

  factory DailyQuestionCard.empty() {
    return DailyQuestionCard(
      question: const Question(),
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ("${question.frontendQuestionId}. ") +
                  (question.title ?? "No Title"),
              style:
                  textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                QuestionDifficultyText(question),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: onSolveTapped,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Solve",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // if (question.paidOnly != null)
      //   Text(
      //     question.paidOnly! ? "Paid Only" : "Free",
      //     style: TextStyle(
      //         color: question.paidOnly! ? Colors.red : Colors.green,
      //         fontWeight: FontWeight.w500),
      //   ),
      // const SizedBox(height: 16),
      // const Text(
      //   "Tags:",
      //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      // ),
      // const SizedBox(height: 8),
      // Wrap(
      //   spacing: 8,
      //   children: question.topicTags != null
      //       ? question.topicTags!.map((tag) {
      //           return Chip(
      //             label: Text(tag.name ?? "N/A"),
      //             backgroundColor: Theme.of(context).colorScheme.surface,
      //           );
      //         }).toList()
      //       : [const Text("No Tags Available")],
      // ),
      // const SizedBox(height: 16),
      //   Row(
      //     children: [
      //       if (question.hasVideoSolution != null)
      //         Icon(
      //           question.hasVideoSolution!
      //               ? Icons.play_circle_fill
      //               : Icons.play_circle_outline,
      //           color: Colors.orange,
      //         ),
      //       const SizedBox(width: 8),
      //       const Text("Video Solution Available"),
      //     ],
      //   ),
      //   const SizedBox(height: 8),
      //   Row(
      //     children: [
      //       if (question.hasSolution != null)
      //         Icon(
      //           question.hasSolution!
      //               ? Icons.description
      //               : Icons.description_outlined,
      //           color: Colors.blue,
      //         ),
      //       const SizedBox(width: 8),
      //       const Text("Text Solution Available"),
      //     ],
      //   ),
    );
  }
}
