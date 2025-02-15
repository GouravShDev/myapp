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
        scheduledContests: Set.from(
          scheduledNotifications
              .map(
                (e) => e.title,
              )
              .toList(),
        ),
      ),
    );
  }

  Future<void> scheduleContestNotification(Contest contest) async {
    if (contest.title == null) return;
    if (contest.startTime != null) {
      await _notificationScheduler.scheduleNotification(
        title: contest.title ?? '',
        body: contest.titleSlug ?? '',
        scheduledTime: contest.startTime!,
      );
      final currentState = state;
      if (currentState is ContestReminderLoaded) {
        emit(
          ContestReminderLoaded(
            scheduledContests: currentState.scheduledContests
              ..add(contest.title!),
          ),
        );
      } else {
        emit(
          ContestReminderLoaded(
            scheduledContests: {contest.title!},
          ),
        );
      }
    }
  }
}
