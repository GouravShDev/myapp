import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/utils/inherited_provider.dart';
import 'package:codersgym/features/question/presentation/widgets/question_info_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/presentation/blocs/question_content/question_content_cubit.dart';
import 'package:codersgym/features/question/presentation/widgets/question_difficulty_text.dart';
import 'package:codersgym/injection.dart';
import 'package:collection/collection.dart';

@RoutePage()
class QuestionDetailPage extends HookWidget {
  final Question question;
  const QuestionDetailPage({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final questionContentCubit = getIt.get<QuestionContentCubit>();
    final scrollController = useScrollController();
    useEffect(
      () {
        questionContentCubit.getQuestionContent(question);
        return null;
      },
      [questionContentCubit],
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Question Descption"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              controller: scrollController,
              child: BlocBuilder<QuestionContentCubit,
                  ApiState<Question, Exception>>(
                bloc: questionContentCubit,
                builder: (context, state) {
                  return state.when(
                    onInitial: () => const CircularProgressIndicator(),
                    onLoading: () => const CircularProgressIndicator(),
                    onLoaded: (question) {
                      return InheritedDataProvider(
                        data: scrollController,
                        child: QuestionDetailPageBody(
                          question: question,
                        ),
                      );
                    },
                    onError: (exception) => Text(exception.toString()),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class QuestionDetailPageBody extends StatelessWidget {
  const QuestionDetailPageBody({
    super.key,
    required this.question,
  });

  final Question question;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ("${question.frontendQuestionId}. ") + (question.title ?? ""),
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
          ..._buildHintTiles(context),
        ],
      ),
    );
  }

  QuestionInfoTile _buildTopicTile(BuildContext context) {
    return QuestionInfoTile(
      title: 'Topics',
      icon: Icons.discount_outlined,
      children: [
        Wrap(
          spacing: 8.0,
          children: question.topicTags
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
  }

  List<QuestionInfoTile> _buildHintTiles(BuildContext context) {
    return question.hints?.mapIndexed(
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
        [];
  }
}
