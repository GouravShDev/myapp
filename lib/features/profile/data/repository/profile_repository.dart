import 'package:codersgym/core/api/leetcode_api.dart';
import 'package:codersgym/core/error/exception.dart';
import 'package:codersgym/core/error/result.dart';
import 'package:codersgym/features/profile/data/entity/contest_ranking_info_entity.dart';
import 'package:codersgym/features/profile/data/entity/user_profile_calendar_entity.dart';
import 'package:codersgym/features/profile/data/entity/user_profile_entity.dart';
import 'package:codersgym/features/profile/domain/model/contest_ranking_info.dart';
import 'package:codersgym/features/profile/domain/model/user_profile.dart';
import 'package:codersgym/features/profile/domain/model/user_profile_calendar.dart';
import 'package:codersgym/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImp implements ProfileRepository {
  final LeetcodeApi _leetcodeApi;

  ProfileRepositoryImp(this._leetcodeApi);
  @override
  Future<Result<UserProfile, UserProfileFailure>> getUserProfile(
      String userName) async {
    try {
      final data = await _leetcodeApi.getUserProfile(userName);
      if (data == null) {
        return Failure(
          UserProfileNotFoundFailure(
            username: userName,
          ),
        );
      }
      final userProfile = UserProfileEntity.fromJson(data);
      return Success(userProfile.toUserProfile());
    } catch (e) {
      if (e is ApiNotFoundException) {
        return Failure(
          UserProfileNotFoundFailure(
            username: userName,
          ),
        );
      }
      return Failure(UserProfileFailure());
    }
  }

  @override
  Future<Result<ContestRankingInfo, Exception>> getContestRankingInfo(
    String userName,
  ) async {
    try {
      final data = await _leetcodeApi.getContestRankingInfo(userName);
      if (data == null) {
        return Failure(Exception());
      }
      final contestRankingInfo = ContestRankingInfoEntity.fromJson(data);
      return Success(contestRankingInfo.toContestRankingInfo());
    } catch (e) {
      return Failure(Exception());
    }
  }

  @override
  Future<Result<UserProfileCalendar, Exception>> getUserProfileCalendar(
      String userName) async {
    try {
      final data = await _leetcodeApi.getUserProfileCalendar(userName);
      if (data == null) {
        return Failure(Exception());
      }
      final userProfileCalendarEntity =
          UserProfileCalendarEntity.fromJson(data);
      return Success(userProfileCalendarEntity.toUserProfileCalendar());
    } catch (e) {
      return Failure(Exception());
    }
  }
}
