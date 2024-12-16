import 'dart:convert';
import 'package:collection/collection.dart';

class UserProfile {
  final String? username;
  final String? socialAccounts;
  final String? githubUrl;
  final int? points;
  final int? questionCount;
  final int? testcaseCount;
  final String? realName;
  final List<String>? websites;
  final String? countryName;
  final List<String>? skillTags;
  final String? company;
  final String? school;
  final double? starRating;
  final String? aboutMe;
  final String? userAvatar;
  final int? reputation;
  final int? ranking;
  final List<QuestionCount>? acSubmissionNum;
  final List<QuestionCount>? totalSubmissionNum;
  final List<QuestionCount>? allQuestionsCount;
  final List<LeetCodeBadge>? badges;
  final String? activeBadgeId;
  final StreakCounter? streakCounter;
  final LeetCodeBadge? contestBadge;

  UserProfile({
    this.username,
    this.socialAccounts,
    this.githubUrl,
    this.points,
    this.questionCount,
    this.testcaseCount,
    this.realName,
    this.websites,
    this.countryName,
    this.skillTags,
    this.company,
    this.school,
    this.starRating,
    this.aboutMe,
    this.userAvatar,
    this.reputation,
    this.ranking,
    this.acSubmissionNum,
    this.totalSubmissionNum,
    this.allQuestionsCount,
    this.badges,
    this.activeBadgeId,
    this.streakCounter,
    this.contestBadge,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['matchedUser']?['username'],
      socialAccounts: json['matchedUser']?['socialAccounts'],
      githubUrl: json['matchedUser']?['githubUrl'],
      points: json['matchedUser']?['contributions']?['points'],
      questionCount: json['matchedUser']?['contributions']?['questionCount'],
      testcaseCount: json['matchedUser']?['contributions']?['testcaseCount'],
      realName: json['matchedUser']?['profile']?['realName'],
      websites:
          List<String>.from(json['matchedUser']?['profile']?['websites'] ?? []),
      countryName: json['matchedUser']?['profile']?['countryName'],
      skillTags: List<String>.from(
          json['matchedUser']?['profile']?['skillTags'] ?? []),
      company: json['matchedUser']?['profile']?['company'],
      school: json['matchedUser']?['profile']?['school'],
      starRating:
          (json['matchedUser']?['profile']?['starRating'] as num?)?.toDouble(),
      aboutMe: json['matchedUser']?['profile']?['aboutMe'],
      userAvatar: json['matchedUser']?['profile']?['userAvatar'],
      reputation: json['matchedUser']?['profile']?['reputation'],
      ranking: json['matchedUser']?['profile']?['ranking'],
      acSubmissionNum:
          (json['matchedUser']?['submitStats']?['acSubmissionNum'] as List?)
              ?.map((item) => QuestionCount.fromJson(item))
              .toList(),
      totalSubmissionNum:
          (json['matchedUser']?['submitStats']?['totalSubmissionNum'] as List?)
              ?.map((item) => QuestionCount.fromJson(item))
              .toList(),
      allQuestionsCount: (json['allQuestionsCount'] as List?)
          ?.map((item) => QuestionCount.fromJson(item))
          .toList(),
      activeBadgeId: (json['activeBadgeId']),
      badges: (json['badges'] as List?)
          ?.map((item) => LeetCodeBadge.fromJson(item))
          .toList(),
      streakCounter: json['streakCounter'] != null
          ? StreakCounter.fromJson(json['streakCounter'])
          : null,
    );
  }
}

class QuestionCount {
  int? count;
  String? difficulty;

  QuestionCount({this.count, this.difficulty});

  factory QuestionCount.fromJson(Map<String, dynamic> json) {
    return QuestionCount(
      count: json['count'],
      difficulty: json['difficulty'],
    );
  }
}

class LeetCodeBadge {
  final String? id;
  final String? displayName;
  final String? icon;
  final bool? isExpired;

  LeetCodeBadge({
    required this.id,
    required this.displayName,
    required this.icon,
    required this.isExpired,
  });

  factory LeetCodeBadge.fromJson(Map<String, dynamic> json) {
    return LeetCodeBadge(
      id: json['id'],
      displayName: json['displayName'],
      icon: json['icon'],
      isExpired: json['isExpired'],
    );
  }
}

class StreakCounter {
  final int streakCount;
  final int daysSkipped;
  final bool currentDayCompleted;

  StreakCounter({
    required this.streakCount,
    required this.daysSkipped,
    required this.currentDayCompleted,
  });

  factory StreakCounter.fromJson(Map<String, dynamic> json) {
    return StreakCounter(
      streakCount: json['streakCount'] ?? 0,
      daysSkipped: json['daysSkipped'] ?? 0,
      currentDayCompleted: json['currentDayCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'streakCount': streakCount,
      'daysSkipped': daysSkipped,
      'currentDayCompleted': currentDayCompleted,
    };
  }
}

extension UserProfileExt on UserProfile {
  UserProfileQuestionsStats get questionsStats {
    final easySolved = acSubmissionNum
            ?.firstWhereOrNull(
              (element) => element.difficulty == 'Easy',
            )
            ?.count ??
        0;
    final mediumSolved = acSubmissionNum
            ?.firstWhereOrNull(
              (element) => element.difficulty == 'Medium',
            )
            ?.count ??
        0;
    final hardSolved = acSubmissionNum
            ?.firstWhereOrNull(
              (element) => element.difficulty == 'Hard',
            )
            ?.count ??
        0;
    final totalEasy = allQuestionsCount
            ?.firstWhereOrNull(
              (element) => element.difficulty == 'Easy',
            )
            ?.count ??
        0;
    final totalMedium = allQuestionsCount
            ?.firstWhereOrNull(
              (element) => element.difficulty == 'Medium',
            )
            ?.count ??
        0;

    final totalHard = allQuestionsCount
            ?.firstWhereOrNull(
              (element) => element.difficulty == 'Hard',
            )
            ?.count ??
        0;
    return UserProfileQuestionsStats(
      easySolved: easySolved,
      mediumSolved: mediumSolved,
      hardSolved: hardSolved,
      totalEasy: totalEasy,
      totalMedium: totalMedium,
      totalHard: totalHard,
    );
  }
}

class UserProfileQuestionsStats {
  final int easySolved;
  final int mediumSolved;
  final int hardSolved;
  final int totalEasy;
  final int totalMedium;
  final int totalHard;

  UserProfileQuestionsStats({
    required this.easySolved,
    required this.mediumSolved,
    required this.hardSolved,
    required this.totalEasy,
    required this.totalMedium,
    required this.totalHard,
  });
}
