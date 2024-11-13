import 'package:cached_network_image/cached_network_image.dart';
import 'package:codersgym/features/question/domain/model/contest.dart';
import 'package:flutter/material.dart';
import 'package:codersgym/core/utils/date_time_extension.dart';
import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';

class UpcomingContestCard extends HookWidget {
  final Contest contest;

  const UpcomingContestCard({super.key, required this.contest});

  factory UpcomingContestCard.empty() {
    return UpcomingContestCard(
      contest: Contest(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    // Calculate initial time remaining
    final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final startTime = contest.startTime != null && contest.duration != null
        ? contest.startTime!
                .subtract(
                  Duration(
                    seconds: contest.duration!,
                  ),
                )
                .millisecondsSinceEpoch ~/
            1000
        : currentTime;
    final timeRemaining = useState(
      Duration(
        seconds: startTime - currentTime,
      ),
    );

    // Set up the timer with Flutter Hooks
    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (timeRemaining.value.inSeconds > 0) {
          timeRemaining.value =
              Duration(seconds: timeRemaining.value.inSeconds - 1);
        }
      });
      return timer.cancel;
    }, [timeRemaining.value]);

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              contest.cardImg != null
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12.0)),
                      child: CachedNetworkImage(
                        imageUrl: contest.cardImg!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(height: 150, color: Colors.grey[300]),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.only(left: 12, bottom: 12, top: 40),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.5), // Top transparent black
                        Colors.black
                            .withOpacity(0.0), // Bottom transparent black
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Starts in:",
                        style: textTheme.labelLarge,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        formatTime(timeRemaining.value.inSeconds),
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contest.title ?? "Contest",
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8.0),
                      if (contest.startTime != null)
                        Text(
                          contest.startTime!
                                  .toLocal()
                                  .formatToDayTimeWithTimezone() ??
                              "",
                          style: textTheme.labelMedium
                              ?.copyWith(color: theme.hintColor),
                        ),
                      const SizedBox(height: 8.0),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    // show snackbar comming soon
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Coming Soon"),
                      ),
                    );
                  },
                  child: Text(
                    "Set Reminder",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
