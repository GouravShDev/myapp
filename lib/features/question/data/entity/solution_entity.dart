import 'package:codersgym/features/question/domain/model/solution.dart';

class SolutionEntity {
  String? id;
  String? title;
  String? content;
  String? contentTypeId;
  bool? paidOnly;
  bool? hasVideoSolution;
  bool? paidOnlyVideo;
  bool? canSeeDetail;

  SolutionEntity({
    this.id,
    this.title,
    this.content,
    this.contentTypeId,
    this.paidOnly,
    this.hasVideoSolution,
    this.paidOnlyVideo,
    this.canSeeDetail,
  });

  SolutionEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    contentTypeId = json['contentTypeId'];
    paidOnly = json['paidOnly'];
    hasVideoSolution = json['hasVideoSolution'];
    paidOnlyVideo = json['paidOnlyVideo'];
    canSeeDetail = json['canSeeDetail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['contentTypeId'] = this.contentTypeId;
    data['paidOnly'] = this.paidOnly;
    data['hasVideoSolution'] = this.hasVideoSolution;
    data['paidOnlyVideo'] = this.paidOnlyVideo;
    data['canSeeDetail'] = this.canSeeDetail;

    return data;
  }
}

extension SolutionEntityExt on SolutionEntity {
  Solution toSolution() {
    return Solution(
      id: id,
      title: title,
      content: content,
      contentTypeId: contentTypeId,
      paidOnly: paidOnly,
      hasVideoSolution: hasVideoSolution,
      paidOnlyVideo: paidOnlyVideo,
      canSeeDetail: canSeeDetail,
    );
  }
}
