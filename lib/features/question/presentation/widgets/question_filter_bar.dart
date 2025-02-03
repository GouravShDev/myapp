import 'package:codersgym/features/question/domain/model/problem_sort_option.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/presentation/blocs/question_filter/question_filter_cubit.dart';
import 'package:codersgym/features/question/presentation/widgets/difficulty_dropdown_button.dart';
import 'package:codersgym/features/question/presentation/widgets/question_sort_bottomsheet_button.dart';
import 'package:codersgym/features/question/presentation/widgets/topic_tags_selection_dialog_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionFilterBar extends StatelessWidget {
  const QuestionFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 8,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BlocBuilder<QuestionFilterCubit, QuestionFilterState>(
                buildWhen: (previous, current) =>
                    previous.difficulty != current.difficulty,
                builder: (context, state) {
                  final difficulty = state.difficulty;
                  return DifficultyDropdownButton(
                    key: ValueKey(difficulty),
                    initalValue: difficulty != null
                        ? QuestionDifficulty.fromString(difficulty)
                        : null,
                    onChange: (QuestionDifficulty difficulty) {
                      context.read<QuestionFilterCubit>().setDifficulty(
                            difficulty.slug,
                          );
                    },
                  );
                },
              ),

              BlocBuilder<QuestionFilterCubit, QuestionFilterState>(
                buildWhen: (previous, current) =>
                    previous.topicTags != current.topicTags,
                builder: (context, state) {
                  return TopicTagsSelectionDialogButton(
                    key: ValueKey(state.topicTags),
                    initialValue: state.topicTags,
                    onTopicTagsSelected: (Set<TopicTags> selectedTags) {
                      context.read<QuestionFilterCubit>().setTopicTags(
                            Set<TopicTags>.from(selectedTags),
                          );
                    },
                  );
                },
              ),
              // Sort Button (Similar to Dropdown)

              BlocBuilder<QuestionFilterCubit, QuestionFilterState>(
                buildWhen: (previous, current) =>
                    previous.sortOption != current.sortOption,
                builder: (context, state) {
                  return QuestionSortBottomsheetButton(
                    key: ValueKey(state.sortOption),
                    initialValue: state.sortOption,
                    onSortOptionApply: (ProblemSortOption? selectedSortOption) {
                      context.read<QuestionFilterCubit>().setSortOption(
                            selectedSortOption,
                          );
                    },
                  );
                },
              ),
              InkWell(
                onTap: () {
                  context.read<QuestionFilterCubit>().reset();
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    // Same as dropdown
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).cardColor,
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.restart_alt,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
