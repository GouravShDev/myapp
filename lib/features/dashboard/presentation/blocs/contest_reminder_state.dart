part of 'contest_reminder_cubit.dart';

@immutable
sealed class ContestReminderState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ContestReminderInitial extends ContestReminderState {}

final class ContestReminderLoading extends ContestReminderState {}

final class ContestReminderLoaded extends ContestReminderState {
  final Set<String> scheduledContests;

  ContestReminderLoaded({required this.scheduledContests});

  @override
  List<Object?> get props => [scheduledContests];
}
