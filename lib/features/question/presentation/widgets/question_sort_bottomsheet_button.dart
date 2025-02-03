import 'package:codersgym/features/question/domain/model/problem_sort_option.dart';
import 'package:codersgym/features/question/presentation/widgets/question_sort_bottomsheet.dart';
import 'package:flutter/material.dart';

class QuestionSortBottomsheetButton extends StatelessWidget {
  const QuestionSortBottomsheetButton({
    super.key,
    this.initialValue,
    required this.onSortOptionApply,
  });
  final ProblemSortOption? initialValue;
  final Function(ProblemSortOption? selectedSortOption) onSortOptionApply;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await showModalBottomSheet<ProblemSortOption?>(
          context: context,
          builder: (context) {
            return QuestionSortBottomsheet(
              initialValue: initialValue,
            );
          },
        );
        onSortOptionApply(result);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).cardColor,
        ),
        child: Row(
          children: [
            if (initialValue == null) ...[
              const Icon(
                Icons.sort,
                size: 18,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              initialValue != null ? initialValue!.displayValue : 'Sort',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
