import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gones_starter_kit/bootstrap.dart';
import 'package:gones_starter_kit/constants/app_sizes.dart';
import 'package:gones_starter_kit/routing/app_router.dart';
import 'package:gones_starter_kit/utils/colored_debug_printer.dart';
import 'package:gones_starter_kit/utils/notification_service.dart';

/// The main application widget.
class MyApp extends ConsumerStatefulWidget {
  /// Creates a new instance of the [MyApp] widget.
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  StreamSubscription<String>? _fcmtokenSubscription;

  @override
  void initState() {
    super.initState();

    _setupPushNotifications();
  }

  @override
  void dispose() {
    _fcmtokenSubscription?.cancel();
    super.dispose();
  }

  Future<void> _setupPushNotifications() async {
    // Listen for incoming message while the app is in the foreground
    FirebaseMessaging.onMessage.listen((message) {
      Print.green('DLOG', 'Handling a message in the foreground: ${message.messageId}');
      ref.read(notificationServiceProvider).processDataMessage(message);
    });

    // Listen for incoming message while the app is in the background
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Request permission to display notifications
    // Called only once when the app is first installed
    await FirebaseMessaging.instance.requestPermission();

    // Listen for token refresh and update the token in the backend
    _fcmtokenSubscription = FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      Print.green('DLOG', 'FCM Token: $token');
      ref.read(notificationServiceProvider).registerToken(token);
    });

    // Get any messages which caused the application to open from
    // a terminated state.
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    Print.green('DLOG', 'Handling a message: ${message.messageId}');
    for (final entry in message.data.entries) {
      Print.green('DLOG', 'Data: ${entry.key} -> ${entry.value}');
    }
  }

  /// The primary color of the application.
  static const primaryColor = Colors.green;

  @override
  Widget build(BuildContext context) {
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: goRouter,
      theme: ThemeData(
        colorSchemeSeed: primaryColor,
        unselectedWidgetColor: Colors.grey,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
        ),
        scaffoldBackgroundColor: Colors.grey[200],
        dividerColor: Colors.grey[400],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
        ),
        //! Input Decoration
        inputDecorationTheme: InputDecorationTheme(
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Sizes.p8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Sizes.p8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Sizes.p8),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Sizes.p8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Sizes.p8),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
