import 'package:codersgym/core/error/result.dart';
import 'package:codersgym/features/profile/domain/model/contest_ranking_info.dart';
import 'package:codersgym/features/profile/domain/model/user_profile.dart';
import 'package:codersgym/features/profile/domain/model/user_profile_calendar.dart';

abstract interface class ProfileRepository {
  Future<Result<UserProfile, UserProfileFailure>> getUserProfile(
    String userName,
  );
  Future<Result<ContestRankingInfo, Exception>> getContestRankingInfo(
    String userName,
  );
  Future<Result<UserProfileCalendar, Exception>> getUserProfileCalendar(
    String userName,
  );
}

class UserProfileFailure implements Exception {}

class UserProfileNotFoundFailure implements UserProfileFailure {
  final String username;

  UserProfileNotFoundFailure({required this.username});
  @override
  String toString() {
    return 'User with username $username not found';
  }
}
