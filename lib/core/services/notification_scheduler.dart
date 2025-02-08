// scheduled_notification_manager.dart
import 'dart:convert';

import 'package:codersgym/core/services/local_notification_service.dart';
import 'package:codersgym/core/utils/storage/storage_manager.dart';

enum NotificationType { notification, alarm }

class ScheduledNotification {
  final int id;
  final String title;
  final String body;
  final DateTime scheduledTime;
  final NotificationType type;
  final Map<String, dynamic>? payload;
  final bool isRepeating;
  final Duration? repeatInterval;

  ScheduledNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledTime,
    this.type = NotificationType.notification,
    this.payload,
    this.isRepeating = false,
    this.repeatInterval,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'scheduledTime': scheduledTime.toIso8601String(),
      'type': type.toString(),
      'payload': payload,
      'isRepeating': isRepeating,
      'repeatInterval': repeatInterval?.inSeconds,
    };
  }

  factory ScheduledNotification.fromJson(Map<String, dynamic> json) {
    return ScheduledNotification(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      scheduledTime: DateTime.parse(json['scheduledTime']),
      type: NotificationType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => NotificationType.notification,
      ),
      payload: json['payload'],
      isRepeating: json['isRepeating'] ?? false,
      repeatInterval: json['repeatInterval'] != null
          ? Duration(seconds: json['repeatInterval'])
          : null,
    );
  }
  
  bool get isExpired => !isRepeating && scheduledTime.isBefore(DateTime.now());
}

class NotificationScheduler {
  final StorageManager _storage;
  final LocalNotificationService _notificationService;
 static const String _storageKey = 'scheduled_notifications';
  static const String _lastCleanupKey = 'last_notification_cleanup';
  
  // Cleanup configuration
  static const Duration cleanupInterval = Duration(days: 1);
  static const Duration retentionPeriod = Duration(days: 7);

  NotificationScheduler({
    required StorageManager storage,
    required LocalNotificationService notificationService,
  })  : _storage = storage,
        _notificationService = notificationService;

  Future<List<ScheduledNotification>> getAllScheduledNotifications() async {
    // Attempt cleanup before fetching notifications
    await _attemptCleanup();
    
    final storedData = await _storage.getStringList(_storageKey);
    if (storedData == null) return [];

    return storedData
        .map((item) => ScheduledNotification.fromJson(jsonDecode(item)))
        .toList();
  }
  Future<void> _attemptCleanup() async {
    try {
      final lastCleanupStr = await _storage.getString(_lastCleanupKey);
      final lastCleanup = lastCleanupStr != null 
          ? DateTime.parse(lastCleanupStr)
          : null;

      final now = DateTime.now();
      
      // Check if cleanup is needed
      if (lastCleanup == null || 
          now.difference(lastCleanup) >= cleanupInterval) {
        await cleanupOldNotifications();
      }
    } catch (e) {
      print('Error during cleanup attempt: $e');
    }
  }
  
  Future<bool> cleanupOldNotifications() async {
    try {
      final now = DateTime.now();
      final allNotifications = await getAllScheduledNotifications();
      
      // Filter out expired non-repeating notifications and old completed ones
      final validNotifications = allNotifications.where((notification) {
        if (notification.isRepeating) return true;
        
        // Keep notifications that are either:
        // 1. Not yet expired, or
        // 2. Expired but within retention period
        return !notification.isExpired || 
               now.difference(notification.scheduledTime) <= retentionPeriod;
      }).toList();

      // Cancel expired notifications in the system
      final expiredNotifications = allNotifications
          .where((notification) => notification.isExpired)
          .toList();
      
      for (var notification in expiredNotifications) {
        await _notificationService.cancelNotification(notification.id);
      }

      // Update storage with valid notifications
      final notificationStrings = validNotifications
          .map((notification) => jsonEncode(notification.toJson()))
          .toList();
      
      // Store the cleanup time
      await _storage.putString(
        _lastCleanupKey,
        DateTime.now().toIso8601String(),
      );

      return await _storage.putStringList(_storageKey, notificationStrings);
    } catch (e) {
      print('Error during notification cleanup: $e');
      return false;
    }
  }
 Future<List<ScheduledNotification>> getExpiredNotifications({
    Duration? within,
  }) async {
    final allNotifications = await getAllScheduledNotifications();
    final now = DateTime.now();
    
    return allNotifications.where((notification) {
      if (!notification.isExpired) return false;
      
      if (within != null) {
        final expiryDuration = now.difference(notification.scheduledTime);
        return expiryDuration <= within;
      }
      
      return true;
    }).toList();
  }

  Future<bool> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    NotificationType type = NotificationType.notification,
    Map<String, dynamic>? payload,
    bool isRepeating = false,
    Duration? repeatInterval,
  }) async {
    try {
      // Generate unique ID based on timestamp
      final id = DateTime.now().millisecondsSinceEpoch % 100000;

      final notification = ScheduledNotification(
        id: id,
        title: title,
        body: body,
        scheduledTime: scheduledTime,
        type: type,
        payload: payload,
        isRepeating: isRepeating,
        repeatInterval: repeatInterval,
      );

      // Schedule the actual notification
      if (type == NotificationType.alarm) {
        // Configure with alarm sound and different channel for alarm type
        await _notificationService.scheduleNotification(
          id: id,
          title: title,
          body: body,
          scheduledDate: scheduledTime,
          payload: jsonEncode(payload),
        );
      } else {
        await _notificationService.scheduleNotification(
          id: id,
          title: title,
          body: body,
          scheduledDate: scheduledTime,
          payload: jsonEncode(payload),
        );
      }

      // Store notification data
      final existingNotifications = await getAllScheduledNotifications();
      existingNotifications.add(notification);

      final notificationStrings = existingNotifications
          .map((notification) => jsonEncode(notification.toJson()))
          .toList();

      return await _storage.putStringList(_storageKey, notificationStrings);
    } catch (e) {
      print('Error scheduling notification: $e');
      return false;
    }
  }

 Future<Map<String, int>> getNotificationStats() async {
    final allNotifications = await getAllScheduledNotifications();
    final now = DateTime.now();
    
    int activeCount = 0;
    int expiredCount = 0;
    int repeatingCount = 0;
    
    for (var notification in allNotifications) {
      if (notification.isRepeating) {
        repeatingCount++;
        activeCount++;
      } else if (notification.isExpired) {
        expiredCount++;
      } else {
        activeCount++;
      }
    }
    
    return {
      'active': activeCount,
      'expired': expiredCount,
      'repeating': repeatingCount,
      'total': allNotifications.length,
    };
  }
  Future<bool> cancelNotification(int id) async {
    try {
      // Cancel the actual notification
      await _notificationService.cancelNotification(id);

      // Remove from storage
      final existingNotifications = await getAllScheduledNotifications();
      final updatedNotifications = existingNotifications
          .where((notification) => notification.id != id)
          .toList();

      final notificationStrings = updatedNotifications
          .map((notification) => jsonEncode(notification.toJson()))
          .toList();

      return await _storage.putStringList(_storageKey, notificationStrings);
    } catch (e) {
      print('Error canceling notification: $e');
      return false;
    }
  }

  Future<bool> cancelAllNotifications() async {
    try {
      await _notificationService.cancelAllNotifications();
      return await _storage.clearKey(_storageKey);
    } catch (e) {
      print('Error canceling all notifications: $e');
      return false;
    }
  }

  Future<List<ScheduledNotification>> getUpcomingNotifications() async {
    final allNotifications = await getAllScheduledNotifications();
    final now = DateTime.now();

    return allNotifications
        .where((notification) => notification.scheduledTime.isAfter(now))
        .toList()
      ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
  }

  Future<List<ScheduledNotification>> getNotificationsByType(
      NotificationType type) async {
    final allNotifications = await getAllScheduledNotifications();
    return allNotifications
        .where((notification) => notification.type == type)
        .toList();
  }

  Future<bool> updateNotification({
    required int id,
    String? title,
    String? body,
    DateTime? scheduledTime,
    Map<String, dynamic>? payload,
  }) async {
    try {
      final existingNotifications = await getAllScheduledNotifications();
      final notificationIndex = existingNotifications
          .indexWhere((notification) => notification.id == id);

      if (notificationIndex == -1) return false;

      final oldNotification = existingNotifications[notificationIndex];

      // Create updated notification
      final updatedNotification = ScheduledNotification(
        id: id,
        title: title ?? oldNotification.title,
        body: body ?? oldNotification.body,
        scheduledTime: scheduledTime ?? oldNotification.scheduledTime,
        type: oldNotification.type,
        payload: payload ?? oldNotification.payload,
        isRepeating: oldNotification.isRepeating,
        repeatInterval: oldNotification.repeatInterval,
      );

      // Cancel existing notification
      await _notificationService.cancelNotification(id);

      // Schedule updated notification
      await _notificationService.scheduleNotification(
        id: id,
        title: updatedNotification.title,
        body: updatedNotification.body,
        scheduledDate: updatedNotification.scheduledTime,
        payload: jsonEncode(updatedNotification.payload),
      );

      // Update storage
      existingNotifications[notificationIndex] = updatedNotification;
      final notificationStrings = existingNotifications
          .map((notification) => jsonEncode(notification.toJson()))
          .toList();

      return await _storage.putStringList(_storageKey, notificationStrings);
    } catch (e) {
      print('Error updating notification: $e');
      return false;
    }
  }
}
