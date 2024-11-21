import 'package:codersgym/features/profile/domain/model/user_profile.dart';
class CommunitySolutionPost {
  final int? id;
  final int? voteCount;
  final int? voteStatus;
  final String? content;
  final int? updationDate;
  final int? creationDate;
  final CommunityPostAuthor? author;
  final bool? authorIsModerator;
  final bool? isOwnPost;

  CommunitySolutionPost({
    required this.id,
    required this.voteCount,
    required this.voteStatus,
    required this.content,
    required this.updationDate,
    required this.creationDate,
    required this.author,
    required this.authorIsModerator,
    required this.isOwnPost,
  });

  CommunitySolutionPost copyWith({
    int? id,
    int? voteCount,
    int? voteStatus,
    String? content,
    int? updationDate,
    int? creationDate,
    CommunityPostAuthor? author,
    bool? authorIsModerator,
    bool? isOwnPost,
  }) {
    return CommunitySolutionPost(
      id: id ?? this.id,
      voteCount: voteCount ?? this.voteCount,
      voteStatus: voteStatus ?? this.voteStatus,
      content: content ?? this.content,
      updationDate: updationDate ?? this.updationDate,
      creationDate: creationDate ?? this.creationDate,
      author: author ?? this.author,
      authorIsModerator: authorIsModerator ?? this.authorIsModerator,
      isOwnPost: isOwnPost ?? this.isOwnPost,
    );
  }
}

class CommunityPostAuthor {
  final bool? isDiscussAdmin;
  final bool? isDiscussStaff;
  final String? username;
  final LeetCodeBadge? activeBadge;
  final UserProfile? profile;
  final bool? isActive;

  CommunityPostAuthor({
    required this.isDiscussAdmin,
    required this.isDiscussStaff,
    required this.username,
    required this.activeBadge,
    required this.profile,
    required this.isActive,
  });

  CommunityPostAuthor copyWith({
    bool? isDiscussAdmin,
    bool? isDiscussStaff,
    String? username,
    LeetCodeBadge? activeBadge,
    UserProfile? profile,
    bool? isActive,
  }) {
    return CommunityPostAuthor(
      isDiscussAdmin: isDiscussAdmin ?? this.isDiscussAdmin,
      isDiscussStaff: isDiscussStaff ?? this.isDiscussStaff,
      username: username ?? this.username,
      activeBadge: activeBadge ?? this.activeBadge,
      profile: profile ?? this.profile,
      isActive: isActive ?? this.isActive,
    );
  }
}

class CommunityAuthorEntity {
  final bool? isDiscussAdmin;
  final bool? isDiscussStaff;
  final String? username;
  final Null? nameColor;
  final LeetCodeBadge? activeBadge;
  final UserProfile? profile;
  final bool? isActive;

  CommunityAuthorEntity({
    this.isDiscussAdmin,
    this.isDiscussStaff,
    this.username,
    this.nameColor,
    this.activeBadge,
    this.profile,
    this.isActive,
  });

  CommunityAuthorEntity copyWith({
    bool? isDiscussAdmin,
    bool? isDiscussStaff,
    String? username,
    Null? nameColor,
    LeetCodeBadge? activeBadge,
    UserProfile? profile,
    bool? isActive,
  }) {
    return CommunityAuthorEntity(
      isDiscussAdmin: isDiscussAdmin ?? this.isDiscussAdmin,
      isDiscussStaff: isDiscussStaff ?? this.isDiscussStaff,
      username: username ?? this.username,
      nameColor: nameColor ?? this.nameColor,
      activeBadge: activeBadge ?? this.activeBadge,
      profile: profile ?? this.profile,
      isActive: isActive ?? this.isActive,
    );
  }
}
