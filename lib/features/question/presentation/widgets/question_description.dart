import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/api/leetcode_api.dart';
import 'package:codersgym/core/routes/app_router.gr.dart';
import 'package:codersgym/core/utils/inherited_provider.dart';
import 'package:codersgym/features/common/widgets/app_webview.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/presentation/blocs/question_content/question_content_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/question_hints/question_hints_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/question_tags/question_tags_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/similar_question/similar_question_cubit.dart';
import 'package:codersgym/features/question/presentation/widgets/question_difficulty_text.dart';
import 'package:codersgym/features/question/presentation/widgets/question_info_tile.dart';
import 'package:codersgym/injection.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class QuestionDescription extends HookWidget {
  QuestionDescription({
    Key? key,
    required this.question,
  }) : super(key: key);

  final Question question;

  @override
  Widget build(BuildContext context) {
    final similarQuestionCubit = context.read<SimilarQuestionCubit>();
    useEffect(() {
      similarQuestionCubit.getSimilarQuestions(question);
      return null;
    }, []);
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      controller: InheritedDataProvider.of<ScrollController>(context),
      child: BlocBuilder<QuestionContentCubit, QuestionContentState>(
        builder: (context, state) {
          return state.when(
            onInitial: () => const CircularProgressIndicator(),
            onLoading: () => const CircularProgressIndicator(),
            onLoaded: (question) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        ("${question.frontendQuestionId}. ") +
                            (question.title ?? ""),
                        style: textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    QuestionDifficultyText(question),
                    HtmlWidget(
                      question.content ?? '',
                      renderMode: RenderMode.column,
                      textStyle: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    _buildTopicTile(context),
                    _buildHintTiles(context),
                    BlocBuilder<SimilarQuestionCubit, SimilarQuestionState>(
                      bloc: similarQuestionCubit,
                      builder: (context, state) {
                        return state.when(
                          onInitial: () => const SizedBox.shrink(),
                          onLoading: () => const SizedBox.shrink(),
                          onLoaded: (similarQuestionList) {
                            return _buildSimilarQuestionsTiles(
                              context,
                              similarQuestionList,
                            );
                          },
                          onError: (exception) => Text(exception.toString()),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
            onError: (exception) => Text(exception.toString()),
          );
        },
      ),
    );
  }

  Widget _buildTopicTile(BuildContext context) {
    return BlocBuilder<QuestionTagsCubit, QuestionTagsState>(
      builder: (context, state) {
        return state.when(
          onInitial: () => SizedBox.shrink(),
          onLoading: () => SizedBox.shrink(),
          onLoaded: (topicTags) {
            if (topicTags.isEmpty) {
              return SizedBox.shrink();
            }
            return QuestionInfoTile(
              title: 'Topics',
              icon: Icons.discount_outlined,
              children: [
                Wrap(
                  spacing: 8.0,
                  children: topicTags
                          ?.map(
                            (e) => e.name ?? '',
                          )
                          .toList()
                          ?.map(
                            (tag) => Chip(
                              label: Text(tag),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: BorderSide(
                                  color: Theme.of(context).cardColor,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          )
                          .toList() ??
                      [],
                ),
              ],
            );
          },
          onError: (exception) {
            return Text(exception.toString());
          },
        );
      },
    );
  }

  Widget _buildHintTiles(BuildContext context) {
    return BlocBuilder<QuestionHintsCubit, QuestionHintsState>(
      builder: (context, state) {
        return state.when(
          onInitial: () => SizedBox.shrink(),
          onLoading: () => SizedBox.shrink(),
          onLoaded: (hints) {
            return Column(
              children: hints?.mapIndexed(
                    (
                      index,
                      hint,
                    ) {
                      return QuestionInfoTile(
                        title: 'Hint ${index + 1}',
                        icon: Icons.lightbulb_outline_sharp,
                        children: [
                          Text(hint),
                        ],
                      );
                    },
                  ).toList() ??
                  [],
            );
          },
          onError: (exception) => Text(
            exception.toString(),
          ),
        );
      },
    );
  }

  Widget _buildSimilarQuestionsTiles(
      BuildContext context, List<Question>? similarQuestions) {
    if (similarQuestions == null || similarQuestions.isEmpty) {
      return const SizedBox.shrink();
    }
    return QuestionInfoTile(
      title: 'Similar Questions',
      icon: Icons.sticky_note_2_rounded,
      children: similarQuestions
          .map(
            (question) => InkWell(
              onTap: () {
                AutoRouter.of(context)
                    .push(QuestionDetailRoute(question: question));
              },
              child: Card(
                color: Theme.of(context).focusColor.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ).copyWith(
                    left: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          question.title ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      QuestionDifficultyText(
                        question,
                        showLabel: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
