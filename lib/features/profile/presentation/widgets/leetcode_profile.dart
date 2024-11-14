import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/core/utils/date_time_extension.dart';
import 'package:codersgym/features/common/widgets/app_loading.dart';
import 'package:codersgym/features/profile/domain/model/contest_ranking_info.dart';
import 'package:codersgym/features/profile/domain/model/user_profile_calendar.dart';
import 'package:codersgym/features/profile/presentation/blocs/contest_ranking_info/contest_ranking_info_cubit.dart';
import 'package:codersgym/features/profile/presentation/blocs/cubit/user_profile_calendar_cubit.dart';
import 'package:codersgym/features/profile/presentation/widgets/badge_carousel.dart';
import 'package:codersgym/features/profile/presentation/widgets/leetcode_rating_details.dart';
import 'package:codersgym/features/profile/presentation/widgets/question_solved.dart';
import 'package:codersgym/features/profile/presentation/widgets/submission_heat_map_calendart.dart';
import 'package:codersgym/features/profile/presentation/widgets/user_profile_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../../injection.dart';
import '../../domain/model/user_profile.dart';
import 'leetcode_user_profile_card.dart';

class LeetcodeProfile extends HookWidget {
  const LeetcodeProfile({
    super.key,
    required this.userProfile,
  });
  final UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final questionStats = userProfile.questionsStats;
    final contestRankingInfoCubit = getIt.get<ContestRankingInfoCubit>();
    final userProfileCalendarCubit = getIt.get<UserProfileCalendarCubit>();
    useEffect(() {
      contestRankingInfoCubit.getContestRankingInfo(userProfile.username ?? '');
      userProfileCalendarCubit
          .getUserProfileSubmissionCalendar(userProfile.username ?? '');
      return null;
    }, []);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LeetcodeUserProfileCard(
              userProfile: userProfile,
            ),
          ),
          const SizedBox(height: 16),
          if (userProfile.badges?.isNotEmpty ?? false) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "Badges : ",
                    style:
                        textTheme.titleMedium?.copyWith(color: theme.hintColor),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    userProfile.badges!.length.toString(),
                    style: textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            // const SizedBox(height: 2),
            BadgeCarousel(
              badges: userProfile.badges!,
            ),
          ],
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Contest Ratings",
              style: textTheme.titleMedium?.copyWith(color: theme.hintColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<ContestRankingInfoCubit,
                ApiState<ContestRankingInfo, Exception>>(
              bloc: contestRankingInfoCubit,
              builder: (context, state) {
                return state.when(
                  onInitial: () =>
                      const Center(child: CircularProgressIndicator()),
                  onLoading: () {
                    return AppWidgetLoading(
                      child: LeetcodeRatingDetails.empty(),
                    );
                  },
                  onLoaded: (contestRankingInfo) {
                    return LeetcodeRatingDetails(
                      contestRankingInfo: contestRankingInfo,
                    );
                  },
                  onError: (exception) => Text(exception.toString()),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          DifficultySpeedometer(
            easyCount: questionStats.easySolved,
            mediumCount: questionStats.mediumSolved,
            hardCount: questionStats.hardSolved,
            totalEasyCount: questionStats.totalEasy,
            totalMediumCount: questionStats.totalMedium,
            totalHardCount: questionStats.totalHard,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Submission",
              style: textTheme.titleMedium?.copyWith(color: theme.hintColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<UserProfileCalendarCubit,
                ApiState<UserProfileCalendar, Exception>>(
              bloc: userProfileCalendarCubit,
              builder: (context, state) {
                return state.when(
                  onInitial: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  onLoading: () => const SubmissionHeatMapCalendar(
                    dataSets: {},
                  ),
                  onLoaded: (calendar) {
                    final dataSet = calendar.submissionCalendar?.map(
                      (e) {
                        // Convert timestamp to DateTime and multiply by 1000 to get milliseconds
                        return MapEntry(
                          DateTime.fromMillisecondsSinceEpoch(
                            e.timeStamp * 1000,
                          ).onlyDate,
                          e.submissionCount,
                        );
                      },
                    );
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            UserProfileInfo(
                              title: "Total Active Days",
                              data: calendar.totalActiveDays.toString(),
                            ),
                            UserProfileInfo(
                              title: "Max Streak",
                              data: calendar.streak.toString(),
                            ),
                            UserProfileInfo(
                              title: "Total Submission",
                              data: (calendar.submissionCalendar?.length ?? 0)
                                  .toString(),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        SubmissionHeatMapCalendar(
                          dataSets: Map.fromEntries(
                            dataSet ?? [],
                          ),
                        ),
                      ],
                    );
                  },
                  onError: (exception) => Text(exception.toString()),
                );
              },
            ),
          ),
     
        ],
      ),
    );
  }
}
