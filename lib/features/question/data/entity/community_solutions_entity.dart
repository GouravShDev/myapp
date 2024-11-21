import 'package:codersgym/features/question/data/entity/community_post_detail_entity.dart';
import 'package:codersgym/features/question/data/entity/community_post_entity.dart';

class CommunitySolutionListEntity {
  QuestionSolutionsNodeEntity? questionSolutions;

  CommunitySolutionListEntity({this.questionSolutions});

  CommunitySolutionListEntity.fromJson(Map<String, dynamic> json) {
    questionSolutions = json['questionSolutions'] != null
        ? new QuestionSolutionsNodeEntity.fromJson(json['questionSolutions'])
        : null;
  }
}

class QuestionSolutionsNodeEntity {
  bool? hasDirectResults;
  int? totalNum;
  List<CommunityPostDetailEntity>? solutions;

  QuestionSolutionsNodeEntity(
      {this.hasDirectResults, this.totalNum, this.solutions});

  QuestionSolutionsNodeEntity.fromJson(Map<String, dynamic> json) {
    hasDirectResults = json['hasDirectResults'];
    totalNum = json['totalNum'];
    if (json['solutions'] != null) {
      solutions = <CommunityPostDetailEntity>[];
      json['solutions'].forEach((v) {
        solutions!.add(new CommunityPostDetailEntity.fromJson(v));
      });
    }
  }
}
