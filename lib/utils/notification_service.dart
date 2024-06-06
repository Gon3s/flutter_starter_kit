import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_service.g.dart';

/// A reference to the [NotificationService].
@Riverpod(keepAlive: true)
NotificationService notificationService(NotificationServiceRef ref) {
  return NotificationService(ref: ref);
}

/// A service to handle push notifications.
class NotificationService {
  ///
  NotificationService({required this.ref});

  ///
  final NotificationServiceRef ref;

  /// Register the device for push notifications.
  Future<void> registerDevice() async {
    final token = await FirebaseMessaging.instance.getToken();
    debugPrint('Token: $token');
  }

  /// Unregister the device from push notifications.
  Future<void> unregisterDevice() async {
    return Future.value();
  }

  /// Process a message received while the app is in the foreground.
  Future<void> processDataMessage(RemoteMessage message) async {
    debugPrint('processing message received in foreground: $message');
  }
}
