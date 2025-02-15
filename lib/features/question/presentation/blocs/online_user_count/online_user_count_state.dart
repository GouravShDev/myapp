part of 'online_user_count_cubit.dart';

sealed class OnlineUserCountState extends Equatable {
  const OnlineUserCountState();

  @override
  List<Object> get props => [];
}

final class OnlineUserCountInitialState extends OnlineUserCountState {}

final class OnlineUserCountConnectingState extends OnlineUserCountState {}

final class OnlineUserCountConnectedState extends OnlineUserCountState {
  final int userCount;

  const OnlineUserCountConnectedState({required this.userCount});

  @override
  List<Object> get props => [userCount];
}

final class OnlineUserCountConnectionFailedState extends OnlineUserCountState {}