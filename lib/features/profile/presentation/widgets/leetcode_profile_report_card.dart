import 'dart:io';
import 'dart:math';

import 'package:codersgym/core/utils/app_constants.dart';
import 'package:codersgym/features/common/widgets/app_loading.dart';
import 'package:codersgym/features/profile/domain/model/contest_ranking_info.dart';
import 'package:codersgym/features/profile/domain/model/user_profile.dart';
import 'package:codersgym/features/profile/domain/model/user_profile_calendar.dart';
import 'package:codersgym/features/profile/presentation/blocs/contest_ranking_info/contest_ranking_info_cubit.dart';
import 'package:codersgym/features/profile/presentation/blocs/cubit/user_profile_calendar_cubit.dart';
import 'package:codersgym/features/profile/presentation/widgets/leetcode_rating_chart.dart';
import 'package:codersgym/features/profile/presentation/widgets/leetcode_rating_details.dart';
import 'package:codersgym/features/profile/presentation/widgets/leetcode_user_profile_card.dart';
import 'package:codersgym/features/profile/presentation/widgets/user_badges_list.dart';

import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:codersgym/features/profile/presentation/widgets/user_profile_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:codersgym/core/utils/number_extension.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:collection/collection.dart';

class LeetcodeProfileReportCard extends HookWidget {
  const LeetcodeProfileReportCard({
    super.key,
    required this.userProfile,
    required this.contestRankingInfoCubit,
    required this.userProfileCalendarCubit,
  });
  final UserProfile userProfile;
  final ContestRankingInfoCubit contestRankingInfoCubit;
  final UserProfileCalendarCubit userProfileCalendarCubit;

  static void show(
    BuildContext context, {
    required UserProfile profile,
    required ContestRankingInfoCubit rankingInfoCubit,
    required UserProfileCalendarCubit profileCalendarCubit,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: rankingInfoCubit,
            ),
            BlocProvider.value(
              value: profileCalendarCubit,
            ),
          ],
          child: LeetcodeProfileReportCard(
            userProfile: profile,
            contestRankingInfoCubit: rankingInfoCubit,
            userProfileCalendarCubit: profileCalendarCubit,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsToImageController to access widget
    final controller = WidgetsToImageController();
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
// to save image bytes of widget
    // useEffect(() {
    //   return () => controller.dispose();
    // }, []);
    Uint8List? bytes;
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      content: BlocBuilder<ContestRankingInfoCubit, ContestRankingInfoState>(
          builder: (context, state) {
        return state.when(
          onInitial: () => const Center(child: CircularProgressIndicator()),
          onLoading: () {
            return AppWidgetLoading(
              child: LeetcodeRatingDetails.empty(),
            );
          },
          onError: (exception) => Text(exception.toString()),
          onLoaded: (contestRankingInfo) {
            return BlocBuilder<UserProfileCalendarCubit,
                UserProfileCalendarState>(
              builder: (context, state) {
                return state.when(
                    onInitial: () =>
                        const Center(child: CircularProgressIndicator()),
                    onLoading: () {
                      return AppWidgetLoading(
                        child: LeetcodeRatingDetails.empty(),
                      );
                    },
                    onError: (exception) => Text(exception.toString()),
                    onLoaded: (userProfileCalendar) {
                      return Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: Theme.of(context).dividerColor,
                                ),
                              ),
                              child: WidgetsToImage(
                                controller: controller,
                                child: SizedBox(
                                  // width:
                                  //     AppConstants.profileReportWidth.toDouble(),
                                  // height:
                                  //     AppConstants.profileReportHeight.toDouble(),
                                  child: AspectRatio(
                                    aspectRatio: (AppConstants
                                            .profileReportWidth
                                            .toDouble()) /
                                        AppConstants.profileReportHeight
                                            .toDouble(),
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  radius: 32,
                                                  backgroundImage: NetworkImage(
                                                      userProfile.userAvatar ??
                                                          ""),
                                                ),
                                                const SizedBox(width: 12),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      userProfile.realName ??
                                                          "N/A",
                                                      style: textTheme
                                                          .titleMedium
                                                          ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          userProfile
                                                                  .username ??
                                                              "N/A",
                                                          style: textTheme
                                                              .titleMedium
                                                              ?.copyWith(
                                                                  color: theme
                                                                      .hintColor),
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                if (userProfile.contestBadge !=
                                                        null &&
                                                    userProfile.contestBadge
                                                            ?.icon !=
                                                        null)
                                                  Column(
                                                    children: [
                                                      Image.network(
                                                        userProfile
                                                            .contestBadge!
                                                            .icon!,
                                                        width: 46,
                                                      ),
                                                      Text(
                                                        userProfile.contestBadge
                                                                ?.displayName ??
                                                            '',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium
                                                            ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Rank : ",
                                                      style: textTheme
                                                          .titleMedium
                                                          ?.copyWith(
                                                        color: colorScheme
                                                            .outline
                                                            .withOpacity(0.8),
                                                      ),
                                                    ),
                                                    Text(
                                                      userProfile.ranking
                                                              ?.toReadableNumber
                                                              .toString() ??
                                                          "N/A",
                                                      style: textTheme
                                                          .titleMedium
                                                          ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Rating : ",
                                                      style: textTheme
                                                          .titleMedium
                                                          ?.copyWith(
                                                        color: colorScheme
                                                            .outline
                                                            .withOpacity(0.8),
                                                      ),
                                                    ),
                                                    Text(
                                                      contestRankingInfo.rating
                                                              ?.toInt()
                                                              .toString() ??
                                                          "N/A",
                                                      style: textTheme
                                                          .titleMedium
                                                          ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),

                                            Builder(builder: (context) {
                                              final activeBadge = userProfile
                                                  .badges
                                                  ?.firstWhereOrNull((badge) =>
                                                      badge.id ==
                                                      userProfile
                                                          .activeBadgeId);
                                              final restOfBadges =
                                                  userProfile.badges
                                                      ?.where(
                                                        (element) =>
                                                            element.id !=
                                                                userProfile
                                                                    .activeBadgeId &&
                                                            element.id !=
                                                                userProfile
                                                                    .contestBadge
                                                                    ?.id,
                                                      )
                                                      .toList();
                                              // if (activeBadge == null ||
                                              //     activeBadge.icon == null) {
                                              //   return const SizedBox.shrink();
                                              // }
                                              final badgesCount = min(
                                                  7,
                                                  (restOfBadges?.length ?? 0) +
                                                      ((activeBadge != null)
                                                          ? 1
                                                          : 0));
                                              final middleIndex =
                                                  (badgesCount / 2).floor();
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: List.generate(
                                                  badgesCount,
                                                  (index) {
                                                    if (index == middleIndex &&
                                                        activeBadge != null) {
                                                      return Image.network(
                                                        activeBadge.icon!,
                                                        height: 54,
                                                      );
                                                    }
                                                    final normalBadge =
                                                        restOfBadges?[index];
                                                    if (normalBadge == null)
                                                      return SizedBox.shrink();
                                                    return Image.network(
                                                      normalBadge.icon!,
                                                      height: 32,
                                                    );
                                                  },
                                                ),
                                              );
                                            }),
                                            // userProfile.activeBadgeId

                                            Row(
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    UserProfileInfo(
                                                      title: "Top Leetcode",
                                                      data: contestRankingInfo
                                                                  .topPercentage !=
                                                              null
                                                          ? "${contestRankingInfo.topPercentage}%"
                                                          : "0%",
                                                    ),
                                                    UserProfileInfo(
                                                      title: "Global Ranking",
                                                      data: contestRankingInfo
                                                              .globalRanking
                                                              ?.toReadableNumber ??
                                                          "0",
                                                    ),
                                                    UserProfileInfo(
                                                      title: "Attended",
                                                      data: contestRankingInfo
                                                              .attendedContestsCount
                                                              ?.toString() ??
                                                          "0",
                                                    ),
                                                  ],
                                                ),
                                                Builder(builder: (context) {
                                                  final dataPoints =
                                                      contestRankingInfo
                                                          .userContestRankingHistory
                                                          ?.where(
                                                    (e) => e.attended ?? false,
                                                  )
                                                          .mapIndexed(
                                                    (i, e) {
                                                      return DataPoint(
                                                        i.toDouble(),
                                                        e.rating
                                                                ?.toInt()
                                                                .toDouble() ??
                                                            0.0,
                                                      );
                                                    },
                                                  ).toList();
                                                  if (dataPoints?.isEmpty ??
                                                      true) return SizedBox();
                                                  return Expanded(
                                                    child: LeetcodeRatingChart(
                                                      dataPoints:
                                                          dataPoints ?? [],
                                                      showAnimation: false,
                                                      showLeftTile: false,
                                                      showMaxRating: false,
                                                      aspectRatio: 2,
                                                    ),
                                                  );
                                                }),
                                              ],
                                            ),

                                            Builder(builder: (context) {
                                              final easyCount = userProfile
                                                  .questionsStats.easySolved;
                                              final mediumCount = userProfile
                                                  .questionsStats.mediumSolved;
                                              final hardCount = userProfile
                                                  .questionsStats.hardSolved;
                                              final totalEasyCount = userProfile
                                                  .questionsStats.totalEasy;
                                              final totalMediumCount =
                                                  userProfile.questionsStats
                                                      .totalMedium;
                                              final totalHardCount = userProfile
                                                  .questionsStats.totalHard;
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  _buildLegendItem(
                                                    context,
                                                    label: "Easy",
                                                    color: Color(0xff1ABBBB),
                                                    solvedQuestionCount:
                                                        easyCount,
                                                    totalQuestionCount:
                                                        totalEasyCount,
                                                  ),
                                                  _buildLegendItem(
                                                    context,
                                                    label: "Medium",
                                                    color: Color(0xffFEB600),
                                                    solvedQuestionCount:
                                                        mediumCount,
                                                    totalQuestionCount:
                                                        totalMediumCount,
                                                  ),
                                                  _buildLegendItem(
                                                    context,
                                                    label: "Hard",
                                                    color: Color(0xffF53836),
                                                    solvedQuestionCount:
                                                        hardCount,
                                                    totalQuestionCount:
                                                        totalHardCount,
                                                  ),
                                                ],
                                              );
                                            }),
                                            UserProfileCalendarWidget(
                                              profileData: userProfileCalendar,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final imageData = await controller.capture(
                                  pixelRatio:
                                      MediaQuery.devicePixelRatioOf(context));
                              if (imageData == null) return;
                              // showDialog(
                              //   context: context,
                              //   builder: (context) {
                              //     return AlertDialog(
                              //       insetPadding: EdgeInsets.zero,
                              //       contentPadding: EdgeInsets.zero,
                              //       backgroundColor: Colors.black,
                              //       content: Image.memory(imageData),
                              //     );
                              //   },
                              // );
                              _shareImage(context, imageData);
                            },
                            label: Icon(
                              Icons.share_outlined,
                            ),
                          ),
                        ],
                      );
                    });
              },
            );
          },
        );
      }),
    );
  }

  Widget _buildLegendItem(
    BuildContext context, {
    required String label,
    required Color color,
    required int solvedQuestionCount,
    required int totalQuestionCount,
  }) {
    return Card(
      color: Theme.of(context).indicatorColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: solvedQuestionCount.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '/$totalQuestionCount',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<void> _shareImage(BuildContext context, Uint8List imageData) async {
  try {
    // Create a temporary file to share
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/captured_image.png').create();
    await file.writeAsBytes(imageData);

    // Share the file
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Check out this image!',
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to share image: $e')),
    );
  }
}

class UserProfileCalendarWidget extends StatelessWidget {
  final UserProfileCalendar profileData;

  const UserProfileCalendarWidget({Key? key, required this.profileData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Default fallback values
    final activeYears = profileData.activeYears ?? [];
    final streak = profileData.streak ?? 0;
    final totalActiveDays = profileData.totalActiveDays ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active Years
          if (activeYears.isNotEmpty) ...[
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Solving LeetCode Since : ',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  TextSpan(
                    text: activeYears
                        .reduce((curr, next) => curr < next ? curr : next)
                        .toString(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Statistics Grid
          Row(
            children: [
              // Streak Card
              _buildStatCard(
                context,
                icon: Icons.local_fire_department,
                iconColor: Colors.orange,
                title: 'Streak',
                value: streak.toString(),
                valueColor: Colors.green,
                unit: 'days',
              ),
              SizedBox(
                width: 10,
              ),
              // Total Active Days Card
              _buildStatCard(
                context,
                icon: Icons.arrow_upward,
                iconColor: Colors.blue,
                title: 'Total Active',
                value: totalActiveDays.toString(),
                valueColor: Colors.blue,
                unit: 'days',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress Message
          Center(
            child: Text(
              streak > 0
                  ? 'Keep pushing! You\'re on an awesome coding streak!'
                  : 'Start your coding journey today!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build statistic cards
  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required Color valueColor,
    required String unit,
  }) {
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(icon, color: iconColor, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: value,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    TextSpan(
                      text: ' $unit',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
