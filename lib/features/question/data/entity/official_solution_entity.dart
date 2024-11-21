import 'package:codersgym/features/question/data/entity/solution_entity.dart';

class OfficialSolutionEntity {
  QuestionWithSolutionEntity? question;

  OfficialSolutionEntity({this.question});

  OfficialSolutionEntity.fromJson(Map<String, dynamic> json) {
    question = json['question'] != null
        ? QuestionWithSolutionEntity.fromJson(json['question'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (question != null) {
      data['question'] = question!.toJson();
    }
    return data;
  }
}

class QuestionWithSolutionEntity {
  SolutionEntity? solution;

  QuestionWithSolutionEntity({this.solution});

  QuestionWithSolutionEntity.fromJson(Map<String, dynamic> json) {
    solution = json['solution'] != null
        ? SolutionEntity.fromJson(json['solution'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (solution != null) {
      data['solution'] = solution!.toJson();
    }
    return data;
  }
}
