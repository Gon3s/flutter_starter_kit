import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gones_starter_kit/app.dart';
import 'package:gones_starter_kit/app_env.dart';
import 'package:gones_starter_kit/localization/string_hardcoded.dart';
import 'package:gones_starter_kit/utils/colored_debug_printer.dart';

///
Future<void> bootstrap(AppEnvironment environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  // * Init environment
  EnvInfo.environment = environment;
  EnvInfo.describe();

  // * Register error handlers. For more info, see:
  // * https://docs.flutter.dev/testing/errors
  _registerErrorHandlers();

  // * Setup system UI overlay style
  _setupSystemUIOverlayStyle();

  // * Setup Firebase
  await _setupFirebase();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

/// Registers error handlers.
void _registerErrorHandlers() {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    Print.red('DLOG', details.toString());
  };
  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    Print.red('DLOG', error.toString());
    return true;
  };
  // * Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('An error occurred'.hardcoded),
      ),
      body: Center(child: Text(details.toString())),
    );
  };
}

void _setupSystemUIOverlayStyle() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
    ),
  );
}

/// Handles background messages received from Firebase Messaging.
///
/// This function is called when a background message is received by the app.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  Print.green('DLOG', 'Handling a background message: ${message.messageId}');
}

Future<void> _setupFirebase() async {
  await Firebase.initializeApp(
    options: EnvInfo.firebaseOptions,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}
