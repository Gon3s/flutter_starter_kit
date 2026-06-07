import 'dart:async';
import 'dart:ui';

{{#avec_firebase}}
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
{{/avec_firebase}}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{app_name}}/app.dart';
import 'package:{{app_name}}/app_env.dart';
import 'package:{{app_name}}/localization/string_hardcoded.dart';
import 'package:{{app_name}}/utils/colored_debug_printer.dart';

///
Future<void> bootstrap(AppEnvironment environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  EnvInfo.environment = environment;
  EnvInfo.describe();

  _registerErrorHandlers();
  _setupSystemUIOverlayStyle();

  {{#avec_firebase}}
  await _setupFirebase();
  {{/avec_firebase}}

  runApp(const ProviderScope(child: MyApp()));
}

void _registerErrorHandlers() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    Print.red('DLOG', details.toString());
  };
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    Print.red('DLOG', error.toString());
    return true;
  };
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

{{#avec_firebase}}
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  Print.green('DLOG', 'Handling a background message: ${message.messageId}');
}

Future<void> _setupFirebase() async {
  await Firebase.initializeApp(options: EnvInfo.firebaseOptions);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}
{{/avec_firebase}}
