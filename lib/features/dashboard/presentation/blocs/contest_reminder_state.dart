part of 'contest_reminder_cubit.dart';

@immutable
sealed class ContestReminderState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ContestReminderInitial extends ContestReminderState {}

final class ContestReminderLoading extends ContestReminderState {}

final class ContestReminderLoaded extends ContestReminderState {
  final Set<ScheduledContest> scheduledContests;

  ContestReminderLoaded({required this.scheduledContests});

  @override
  List<Object?> get props => [scheduledContests];
}

class ScheduledContest {
  final String titleSlug;
  final int scheduledId;

  ScheduledContest({
    required this.titleSlug,
    required this.scheduledId,
  });
}
