import 'package:codersgym/core/api/leetcode_requests.dart';
import 'package:codersgym/core/error/result.dart';
import 'package:codersgym/core/api/leetcode_api.dart';
import 'package:codersgym/features/profile/data/entity/contest_ranking_info_entity.dart';
import 'package:codersgym/features/question/data/entity/contest_entity.dart';
import 'package:codersgym/features/question/data/entity/daily_question_entity.dart';
import 'package:codersgym/features/question/data/entity/problem_question_entity.dart';
import 'package:codersgym/features/question/data/entity/question_entity.dart';
import 'package:codersgym/features/question/data/entity/similar_question_entity.dart';
import 'package:codersgym/features/question/data/entity/upcoming_contest_entity.dart';
import 'package:codersgym/features/question/domain/model/contest.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/domain/repository/question_repository.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  final LeetcodeApi leetcodeApi;

  QuestionRepositoryImpl(this.leetcodeApi);
  @override
  Future<Result<Question, Exception>> getTodayChallenge() async {
    final data = await leetcodeApi.getDailyQuestion();

    if (data == null) {
      return Failure(Exception("No data found"));
    }
    final question = DailyQuestionEntity.fromJson(data);

    return Success(question.toQuestion());
  }

  @override
  Future<Result<Question, Exception>> getQuestionContent(
      String questiontitleSlug) async {
    final data = await leetcodeApi.getQuestionContent(questiontitleSlug);
    if (data == null) {
      return Failure(Exception("No data found"));
    }
    final question = QuestionNodeEntity.fromJson(data['question']);

    return Success(question.toQuestion());
  }

  @override
  Future<Result<(List<Question>, int totalQuestionCount), Exception>>
      getProblemQuestion(
    ProblemQuestionQueryInput query,
  ) async {
    final data = await leetcodeApi.getProblemsList(
      categorySlug: query.categorySlug,
      filters: query.filters?.toFitlers(),
      limit: query.limit,
      skip: query.skip,
    );
    if (data == null) {
      return Failure(Exception("No data found"));
    }
    final problemset = ProblemsetQuestionsEntity.fromJson(data);
    final questionsList = problemset.problemsetQuestionList?.questions
            ?.map(
              (e) => e.toQuestion(),
            )
            .toList() ??
        [];
    final totalQuestionCount = problemset.problemsetQuestionList?.total ?? 0;

    return Success((
      questionsList,
      totalQuestionCount,
    ));
  }

  @override
  Future<Result<List<Contest>, Exception>> getUpcomingContests() async {
    final data = await leetcodeApi.getUpcomingContest();
    if (data == null) {
      return Failure(Exception("No data found"));
    }
    final contests = UpcomingContestEntity.fromJson(data);
    final contestsList = contests.topTwoContests
        ?.map(
          (e) => e.toContest(),
        )
        .toList();
    if (contestsList?.isEmpty ?? true) {
      return Failure(Exception("No Upcoming Contest found"));
    }
    return Success(contestsList!);
  }

  @override
  Future<Result<List<Question>, Exception>> getSimilarQuestions(
    String questionTitleSlug,
  ) async {
    final data = await leetcodeApi.getSimilarQuestions(questionTitleSlug);
    if (data == null) {
      return Failure(Exception("No data found"));
    }
    final similarQuestions = SimilarQuestionEntity.fromJson(data);
    final similarQuestionsList = similarQuestions.question?.similarQuestionList
        ?.map(
          (e) => e.toQuestion(),
        )
        .toList();
    if (similarQuestionsList?.isEmpty ?? true) {
      return Failure(Exception("No Similar Questions found"));
    }
    return Success(similarQuestionsList!);
  }
}

extension ProblemFilterExt on ProblemFilter {
  Filters toFitlers() {
    return Filters(
      difficulty: difficulty,
      listId: listId,
      orderBy: orderBy,
      searchKeywords: searchKeywords,
      tags: tags,
    );
  }
}
