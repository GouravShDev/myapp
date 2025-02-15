import 'package:bloc/bloc.dart';
import 'package:codersgym/core/services/notification_scheduler.dart';
import 'package:codersgym/features/question/domain/model/contest.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'contest_reminder_state.dart';

class ContestReminderCubit extends Cubit<ContestReminderState> {
  ContestReminderCubit(this._notificationScheduler)
      : super(ContestReminderInitial());
  final NotificationScheduler _notificationScheduler;

  Future<void> checkSchedulesContests() async {
    emit(ContestReminderLoading());
    final scheduledNotifications =
        await _notificationScheduler.getAllScheduledNotifications();
    emit(
      ContestReminderLoaded(
        scheduledContests: Set<ScheduledContest>.from(
          scheduledNotifications
              .map(
                (e) => ScheduledContest(
                  titleSlug: e.payload?['contestTitleSlug'] ?? "",
                  scheduledId: e.id,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Future<void> scheduleContestNotification({
    required Contest contest,
    required Duration reminderOffset,
  }) async {
    if (contest.title == null || contest.startTime == null) return;

    final scheduledTime = contest.startTime!.subtract(reminderOffset);

    if (scheduledTime.isBefore(DateTime.now())) {
      return;
    }

    await _notificationScheduler.scheduleNotification(
        title: 'Upcoming Leetcode Contest: ${contest.title}',
        body:
            'Starts in ${_formatDuration(reminderOffset)}. Get ready to solve some exciting problems!',
        scheduledTime: scheduledTime,
        payload: {
          "contestTitleSlug": contest.titleSlug,
        });

    checkSchedulesContests();
  }

  void cancelContestNotification(ScheduledContest scheduledContest) async {
    await _notificationScheduler.cancelNotification(scheduledContest.scheduledId);
    checkSchedulesContests();
  }
}

String _formatDuration(Duration duration) {
  if (duration.inDays > 0) {
    return '${duration.inDays} day${duration.inDays > 1 ? 's' : ''}';
  } else if (duration.inHours > 0) {
    return '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''}';
  } else if (duration.inMinutes > 0) {
    return '${duration.inMinutes} minute${duration.inMinutes > 1 ? 's' : ''}';
  } else {
    return '${duration.inSeconds} second${duration.inSeconds > 1 ? 's' : ''}';
  }
}
