import 'package:codersgym/core/utils/inherited_provider.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/presentation/blocs/question_solution/question_solution_cubit.dart';
import 'package:codersgym/features/question/presentation/widgets/editorial_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class QuestionEditorial extends HookWidget {
  const QuestionEditorial({
    super.key,
    required this.question,
  });

  final Question question;
  @override
  Widget build(BuildContext context) {
    final questionSolutionCubit = context.read<QuestionSolutionCubit>();
    useEffect(() {
      questionSolutionCubit.getQuestionSolution(question.titleSlug ?? '');
      return null;
    }, []);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final screenSize = MediaQuery.sizeOf(context);

    return BlocBuilder<QuestionSolutionCubit, QuestionSolutionState>(
      builder: (context, state) {
        return state.when(
          onInitial: () => const CircularProgressIndicator(),
          onLoading: () => const CircularProgressIndicator(),
          onLoaded: (solution) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomScrollView(
                controller: InheritedDataProvider.of<ScrollController>(context),
                slivers: [
                  EditorialHtml(
                    solutionContent: solution.content ?? '',
                  ),
                ],
              ),
            );
          },
          onError: (exception) => Text(exception.toString()),
        );
      },
    );
  }
}
