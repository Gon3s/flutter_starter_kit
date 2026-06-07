import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{app_name}}/utils/colored_debug_printer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_service.g.dart';

/// A reference to the [NotificationService].
@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) {
  return NotificationService(ref: ref);
}

/// A service to handle push notifications.
class NotificationService {
  ///
  NotificationService({required this.ref});

  ///
  final Ref ref;

  /// Register the device for push notifications.
  Future<void> registerDevice() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      registerToken(token);
    }
  }

  /// Register the device token.
  /// + Need to call backend API to store the token.
  void registerToken(String token) {
    Print.green('DLOG', 'Register Token: $token');
    //@TODO: Call backend API to store the token
  }

  /// Unregister the device from push notifications.
  Future<void> unregisterDevice() async {
    return Future.value();
  }

  /// Process a message received while the app is in the foreground.
  Future<void> processDataMessage(RemoteMessage message) async {
    Print.green('DLOG', 'processing message received in foreground: $message');
  }
}
