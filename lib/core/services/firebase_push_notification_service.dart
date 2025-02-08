import 'package:codersgym/core/services/local_notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebasePushNotificationService {
  static final FirebasePushNotificationService _instance =
      FirebasePushNotificationService._();
  factory FirebasePushNotificationService() => _instance;
  FirebasePushNotificationService._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission for iOS
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM token
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    // Listen to token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      // TODO: Send new token to your server
      print('New FCM Token: $newToken');
    });

    // Handle incoming messages when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received foreground message: ${message.notification?.title}');
      // You can show a local notification here using LocalNotificationService
      if (message.notification != null) {
        LocalNotificationService().showNotification(
          id: message.hashCode,
          title: message.notification!.title ?? '',
          body: message.notification!.body ?? '',
          payload: message.data.toString(),
        );
      }
    });

    // Handle notification open events when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened app: ${message.notification?.title}');
      // TODO: Handle navigation or other actions based on notification
    });
  }

  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
}
