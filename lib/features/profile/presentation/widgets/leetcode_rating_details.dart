import 'dart:math';

import 'package:collection/collection.dart';
import 'package:codersgym/features/profile/domain/model/contest_ranking_info.dart';
import 'package:codersgym/features/profile/presentation/widgets/leetcode_rating_chart.dart';
import 'package:codersgym/features/profile/presentation/widgets/user_profile_info.dart';
import 'package:codersgym/core/utils/number_extension.dart';
import 'package:flutter/material.dart';

class LeetcodeRatingDetails extends StatelessWidget {
  const LeetcodeRatingDetails({
    super.key,
    required this.contestRankingInfo,
    this.showRatingGraphAnimation = true,
  });
  final ContestRankingInfo contestRankingInfo;
  final bool showRatingGraphAnimation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final dataPoints = contestRankingInfo.userContestRankingHistory
        ?.where(
      (e) => e.attended ?? false,
    )
        .mapIndexed(
      (i, e) {
        return DataPoint(
          i.toDouble(),
          e.rating?.toInt().toDouble() ?? 0.0,
        );
      },
    ).toList();
    if (dataPoints?.isEmpty ?? true) return SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Contest Ratings",
          style: textTheme.titleMedium?.copyWith(color: theme.hintColor),
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            UserProfileInfo(
              title: "Global Ranking",
              data: contestRankingInfo.globalRanking?.toReadableNumber ?? "0",
            ),
            UserProfileInfo(
              title: "Top Leetcode",
              data: contestRankingInfo.topPercentage != null
                  ? "${contestRankingInfo.topPercentage}%"
                  : "0%",
            ),
            UserProfileInfo(
              title: "Attended",
              data: contestRankingInfo.attendedContestsCount?.toString() ?? "0",
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        LeetcodeRatingChart(
          dataPoints: dataPoints ?? [],
          showAnimation: true,
        ),
      ],
    );
  }

  factory LeetcodeRatingDetails.empty() {
    final dummyRating = List.generate(
      10,
      (index) {
        // Parameters for controlling the graph's shape
        double baseRating = 1400; // Starting point
        double linearGrowth = (20 * index).toDouble(); // Growth factor
        double amplitude = 10; // Amplitude for occasional dips
        double frequency =
            0.3; // Frequency of the wave (lower means fewer dips)

        // Generate a rating with growth and occasional downfalls
        int rating = (baseRating +
                linearGrowth +
                amplitude * cos(index * frequency * pi))
            .round();

        return UserContestRankingHistory(
          rating: rating,
          attended: true,
        );
      },
    );
    return LeetcodeRatingDetails(
      contestRankingInfo: ContestRankingInfo(
        userContestRankingHistory: dummyRating,
      ),
      showRatingGraphAnimation: false,
    );
  }
}
