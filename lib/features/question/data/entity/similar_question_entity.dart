import 'package:codersgym/features/question/data/entity/question_entity.dart';

class SimilarQuestionEntity {
  QuestionSimilarQuestionEntity? question;

  SimilarQuestionEntity({this.question});

  SimilarQuestionEntity.fromJson(Map<String, dynamic> json) {
    question =
        json['question'] != null ? QuestionSimilarQuestionEntity.fromJson(json['question']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.question != null) {
      data['question'] = this.question!.toJson();
    }
    return data;
  }
}

class QuestionSimilarQuestionEntity {
  List<QuestionNodeEntity>? similarQuestionList;

  QuestionSimilarQuestionEntity({this.similarQuestionList});

  QuestionSimilarQuestionEntity.fromJson(Map<String, dynamic> json) {
    if (json['similarQuestionList'] != null) {
      similarQuestionList = <QuestionNodeEntity>[];
      json['similarQuestionList'].forEach((v) {
        similarQuestionList!.add(QuestionNodeEntity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.similarQuestionList != null) {
      data['similarQuestionList'] =
          this.similarQuestionList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
