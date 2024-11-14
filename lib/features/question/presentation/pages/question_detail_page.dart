import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/routes/app_router.gr.dart';
import 'package:codersgym/core/utils/inherited_provider.dart';
import 'package:codersgym/features/question/presentation/blocs/similar_question/similar_question_cubit.dart';
import 'package:codersgym/features/question/presentation/widgets/question_info_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
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

    final currentPage = useState(0);

    final tabController = useTabController(initialLength: 3);
    final unselectedColor = Theme.of(context).dividerColor;
    final selectedColor = Theme.of(context).primaryColor;
    useEffect(
      () {
        questionContentCubit.getQuestionContent(question);
        tabController.animation?.addListener(
          () {
            final value = tabController.animation?.value.round();
            if (value != null && value != currentPage.value) {
              currentPage.value = value;
            }
          },
        );
        return null;
      },
      [questionContentCubit],
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Question Descption"),
        ),
        body: BottomBar(
          icon: (width, height) => Center(
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: null,
              icon: Icon(
                Icons.arrow_upward_rounded,
                color: unselectedColor,
                size: width,
              ),
            ),
          ),
          borderRadius: BorderRadius.circular(500),
          duration: const Duration(seconds: 1),
          curve: Curves.decelerate,
          showIcon: true,
          width: MediaQuery.of(context).size.width * 0.8,
          barColor: Theme.of(context).canvasColor,
          start: 2,
          end: 0,
          offset: 10,
          barAlignment: Alignment.bottomCenter,
          iconHeight: 35,
          iconWidth: 35,
          reverse: false,
          hideOnScroll: true,
          scrollOpposite: false,
          onBottomBarHidden: () {},
          onBottomBarShown: () {},
          child: TabBar(
            indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
            controller: tabController,
            dividerColor: Colors.transparent,
            splashBorderRadius: BorderRadius.circular(100),
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 4,
              ),
              insets: EdgeInsets.fromLTRB(16, 0, 16, 8),
            ),
            tabs: [
              SizedBox(
                height: 55,
                width: 40,
                child: Center(
                    child: Icon(
                  Icons.description_outlined,
                  color:
                      currentPage.value == 0 ? selectedColor : unselectedColor,
                )),
              ),
              SizedBox(
                height: 55,
                width: 40,
                child: Center(
                    child: Icon(
                  Icons.menu_book_rounded,
                  color:
                      currentPage.value == 1 ? selectedColor : unselectedColor,
                )),
              ),
              SizedBox(
                height: 55,
                width: 40,
                child: Center(
                    child: Icon(
                  Icons.science_outlined,
                  color:
                      currentPage.value == 2 ? selectedColor : unselectedColor,
                )),
              ),
            ],
          ),
          body: (context, controller) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                controller: controller,
                child: BlocBuilder<QuestionContentCubit,
                    ApiState<Question, Exception>>(
                  bloc: questionContentCubit,
                  builder: (context, state) {
                    return state.when(
                      onInitial: () => const CircularProgressIndicator(),
                      onLoading: () => const CircularProgressIndicator(),
                      onLoaded: (question) {
                        return InheritedDataProvider(
                          data: controller,
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
            );
          },
        ),
      ),
    );
  }
}

class QuestionDetailPageBody extends HookWidget {
  const QuestionDetailPageBody({
    super.key,
    required this.question,
  });

  final Question question;

  @override
  Widget build(BuildContext context) {
    final similarQuestionCubit = getIt.get<SimilarQuestionCubit>();

    useEffect(() {
      similarQuestionCubit.getSimilarQuestions(question);
      return null;
    }, []);
    final textTheme = Theme.of(context).textTheme;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ("${question.frontendQuestionId}. ") + (question.title ?? ""),
              style:
                  textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
        ));
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
