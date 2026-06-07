{{#avec_firebase}}
import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
{{/avec_firebase}}
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
{{#avec_firebase}}
import 'package:{{app_name}}/bootstrap.dart';
{{/avec_firebase}}
import 'package:{{app_name}}/constants/app_sizes.dart';
import 'package:{{app_name}}/routing/app_router.dart';
{{#avec_firebase}}
import 'package:{{app_name}}/utils/colored_debug_printer.dart';
import 'package:{{app_name}}/utils/notification_service.dart';
{{/avec_firebase}}

/// The main application widget.
class MyApp extends ConsumerStatefulWidget {
  /// Creates a new instance of the [MyApp] widget.
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  {{#avec_firebase}}
  StreamSubscription<String>? _fcmTokenSubscription;

  @override
  void initState() {
    super.initState();
    _setupPushNotifications();
  }

  @override
  void dispose() {
    _fcmTokenSubscription?.cancel();
    super.dispose();
  }

  Future<void> _setupPushNotifications() async {
    FirebaseMessaging.onMessage.listen((message) {
      Print.green('DLOG', 'Foreground message: ${message.messageId}');
      ref.read(notificationServiceProvider).processDataMessage(message);
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await FirebaseMessaging.instance.requestPermission();

    _fcmTokenSubscription = FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      Print.green('DLOG', 'FCM Token: $token');
      ref.read(notificationServiceProvider).registerToken(token);
    });

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) _handleMessage(initialMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    Print.green('DLOG', 'Message opened: ${message.messageId}');
  }
  {{/avec_firebase}}
  {{^avec_firebase}}
  @override
  void initState() {
    super.initState();
  }
  {{/avec_firebase}}

  static const primaryColor = Colors.green;

  @override
  Widget build(BuildContext context) {
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: goRouter,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fr'), Locale('en')],
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
        inputDecorationTheme: InputDecorationTheme(
          disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Sizes.p8)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Sizes.p8)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Sizes.p8)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Sizes.p8)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Sizes.p8)),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
