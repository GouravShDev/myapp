import 'package:codersgym/core/theme/app_theme.dart';
import 'package:codersgym/core/utils/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DifficultyDropdownButton extends HookWidget {
  const DifficultyDropdownButton({
    super.key,
    this.initalValue,
    required this.onChange,
  });
  final QuestionDifficulty? initalValue;
  final Function(QuestionDifficulty difficulty) onChange;

  @override
  Widget build(BuildContext context) {
    final selectedDifficulty = useRef<QuestionDifficulty?>(initalValue);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 100),
      child: DropdownButtonFormField<QuestionDifficulty>(
        value: selectedDifficulty.value,
        isDense: true,
        isExpanded: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          filled: true,
          fillColor: Theme.of(context).cardColor,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        borderRadius: BorderRadius.circular(8.0),
        padding: EdgeInsets.zero,
        style: Theme.of(context).textTheme.titleMedium,
        hint: const Text('Difficulty', style: TextStyle(fontSize: 14)),
        items: QuestionDifficulty.values
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e.uiText,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: e.color(context),
                      ),
                ),
              ),
            )
            .toList(),
        onChanged: (QuestionDifficulty? newValue) {
          selectedDifficulty.value = newValue;
          if (newValue != null) onChange(newValue);
        },
      ),
    );
  }
}

enum QuestionDifficulty {
  all,
  easy,
  medium,
  hard;

  String get uiText => name.capitalizeFirstLetter();

  Color color(BuildContext context) => switch (this) {
        QuestionDifficulty.all => Theme.of(context).colorScheme.onSurface,
        QuestionDifficulty.easy => Theme.of(context).colorScheme.successColor,
        QuestionDifficulty.medium => Theme.of(context).colorScheme.primary,
        QuestionDifficulty.hard => Theme.of(context).colorScheme.error,
      };

  factory QuestionDifficulty.fromString(String difficulty) {
    return switch (difficulty.toLowerCase()) {
      'all' => QuestionDifficulty.all,
      'easy' => QuestionDifficulty.easy,
      'medium' => QuestionDifficulty.medium,
      'hard' => QuestionDifficulty.hard,
      _ => throw ArgumentError('Invalid difficulty: $difficulty'),
    };
  }
  String? get slug => switch (this) {
        QuestionDifficulty.all => null,
        QuestionDifficulty.easy => "EASY",
        QuestionDifficulty.medium => "MEDIUM",
        QuestionDifficulty.hard => "HARD",
      };
}
