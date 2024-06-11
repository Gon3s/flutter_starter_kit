import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:gones_starter_kit/utils/colored_debug_printer.dart';

/// Enum to define different environments
enum AppEnvironment {
  /// Development environment
  development,

  /// Production environment
  production
}

/// Class to store the environment information
abstract class EnvInfo {
  /// The current environment
  static AppEnvironment environment = AppEnvironment.development;

  /// Get the current firebase options based on the environment and platform
  static FirebaseOptions get firebaseOptions => environment._currentPlatform;

  /// Check if we are in production environment
  static bool get isProduction => environment == AppEnvironment.production;

  /// Describe the environment in the console
  static void describe() {
    Print.white(
      'ENVIRONMENT',
      ' ---------------------------------------------------------------------------------------',
    );

    Print.yellow(
      'ENVIRONMENT',
      ' | Environment      : $environment',
    );

    Print.white(
      'ENVIRONMENT',
      ' ---------------------------------------------------------------------------------------',
    );
  }
}

extension _EnvProperties on AppEnvironment {
  static const _androidFirebaseOptions = {
    AppEnvironment.development: FirebaseOptions(
      apiKey: 'AIzaSyCyUq_PdjgNEQwRQ9AagE1GGenKea-XFQo',
      appId: '1:648905359006:android:e5133141a1c3fcdce6458f',
      messagingSenderId: '648905359006',
      projectId: 'starter-kit-prod',
      storageBucket: 'starter-kit-prod.appspot.com',
    ),
    AppEnvironment.production: FirebaseOptions(
      apiKey: 'AIzaSyCyUq_PdjgNEQwRQ9AagE1GGenKea-XFQo',
      appId: '1:648905359006:android:2f09a5a29faa667fe6458f',
      messagingSenderId: '648905359006',
      projectId: 'starter-kit-prod',
      storageBucket: 'starter-kit-prod.appspot.com',
    ),
  };

  static const _iosFirebaseOptions = {
    AppEnvironment.development: FirebaseOptions(
      apiKey: 'AIzaSyDRtckUt4wL64j7Mit6AF98ZgonyB83dD8',
      appId: '1:648905359006:ios:38d604569fa97baee6458f',
      messagingSenderId: '648905359006',
      projectId: 'starter-kit-prod',
      storageBucket: 'starter-kit-prod.appspot.com',
      iosBundleId: 'com.gones.starterKit.dev',
    ),
    AppEnvironment.production: FirebaseOptions(
      apiKey: 'AIzaSyDRtckUt4wL64j7Mit6AF98ZgonyB83dD8',
      appId: '1:648905359006:ios:7117593e030e3b22e6458f',
      messagingSenderId: '648905359006',
      projectId: 'starter-kit-prod',
      storageBucket: 'starter-kit-prod.appspot.com',
      iosBundleId: 'com.gones.starterKit',
    ),
  };

  FirebaseOptions get _currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _androidFirebaseOptions[this]!;
      case TargetPlatform.iOS:
        return _iosFirebaseOptions[this]!;
      // ignore: no_default_cases
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}
