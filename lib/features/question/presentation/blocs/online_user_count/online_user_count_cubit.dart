import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:web_socket_channel/web_socket_channel.dart';

part 'online_user_count_state.dart';

class OnlineUserCountCubit extends Cubit<OnlineUserCountState> {
  WebSocketChannel? _channel;
  final String questionTitleSlug;

  OnlineUserCountCubit({required this.questionTitleSlug})
      : super(OnlineUserCountInitialState()) {
    connectToWebSocket();
  }

  void connectToWebSocket() {
    try {
      emit(OnlineUserCountConnectingState());

      final wsUrl = Uri.parse(
          'wss://collaboration-ws.leetcode.com/problems/$questionTitleSlug');
      _channel = WebSocketChannel.connect(wsUrl);

      _channel?.stream.listen(
        (dynamic message) {
          _handleWebSocketMessage(message);
        },
        onError: (error) {
          emit(OnlineUserCountConnectionFailedState());
        },
        onDone: () {
          // Attempt to reconnect when connection is closed
          Future.delayed(const Duration(seconds: 5), () {
            if (state is! OnlineUserCountConnectionFailedState) {
              connectToWebSocket();
            }
          });
        },
      );
    } catch (e) {
      emit(OnlineUserCountConnectionFailedState());
    }
  }

  void _handleWebSocketMessage(dynamic message) {
    try {

      final userCount = int.tryParse(message);
      // Check if the message contains user count information
      if (userCount != null) {
        emit(OnlineUserCountConnectedState(userCount: userCount));
      }
    } catch (e) {
      // Ignore malformed messages
    }
  }

  void reconnect() {
    _channel?.sink.close();
    connectToWebSocket();
  }

  @override
  Future<void> close() {
    _channel?.sink.close();
    return super.close();
  }
}
