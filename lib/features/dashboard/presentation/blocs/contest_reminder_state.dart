part of 'contest_reminder_cubit.dart';

@immutable
sealed class ContestReminderState {}

final class ContestReminderInitial extends ContestReminderState {}

final class ContestReminderLoading extends ContestReminderState {}

final class ContestReminderLoaded extends ContestReminderState {
  final Set<ScheduledContest> scheduledContests;
  final SetReminderError? error;

  ContestReminderLoaded({
    required this.scheduledContests,
    this.error,
  });
}

class ScheduledContest {
  final String titleSlug;
  final int scheduledId;

  ScheduledContest({
    required this.titleSlug,
    required this.scheduledId,
  });
}

enum SetReminderError {
  notificationPermissionDenied,
  notificationPermissionDeniedPermanently,
  alarmNotificationPermissionDenied,
}
