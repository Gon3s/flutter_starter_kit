import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gones_starter_kit/constants/app_sizes.dart';
import 'package:gones_starter_kit/features/authentication/data/auth_session.dart';
import 'package:gones_starter_kit/features/authentication/data/session_storage.dart';
import 'package:gones_starter_kit/features/authentication/domain/auth_repository.dart';
import 'package:gones_starter_kit/utils/notification_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_startup.g.dart';
part 'app_startup.freezed.dart';

/// The application startup provider.
@Riverpod(keepAlive: true)
Future<AppDependencies> appStartup(AppStartupRef ref) async {
  final sessionStore = ref.watch(sessionStorageProvider);

  // * Load the session from the secure storage
  final session = await sessionStore.read();

  if (session != null) {
    await ref.read(authRepositoryProvider).restoreSession(session);

    await ref.read(notificationServiceProvider).registerDevice();
  }

  return AppDependencies(
    authSession: session,
  );
}

/// Represents the dependencies required by the app.
@freezed
class AppDependencies with _$AppDependencies {
  /// Creates a new instance of the [AppDependencies] class.
  const factory AppDependencies({
    required AuthSessionState? authSession,
  }) = _AppDependencies;
}

/// Widget clas to manage asynchronous initialization of the application.
class AppStartupWidget extends ConsumerWidget {
  /// Creates a new instance of the [AppStartupWidget] widget.
  const AppStartupWidget({required this.onLoaded, super.key});

  /// The widget builder to use when the application has loaded.
  final WidgetBuilder onLoaded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStartupState = ref.watch(appStartupProvider);
    return appStartupState.when(
      data: (_) => onLoaded(context),
      loading: () => const AppStartupLoadingWidget(),
      error: (e, st) => AppStartupErrorWidget(
        message: e.toString(),
        onRetry: () => ref.refresh(appStartupProvider),
      ),
    );
  }
}

/// Widget class to display a loading indicator while the application is starting.
class AppStartupLoadingWidget extends StatelessWidget {
  /// Creates a new instance of the [AppStartupLoadingWidget] widget.
  const AppStartupLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

/// Widget class to display an error message when the application fails to start.
class AppStartupErrorWidget extends StatelessWidget {
  /// Creates a new instance of the [AppStartupErrorWidget] widget.
  const AppStartupErrorWidget({
    required this.message,
    required this.onRetry,
    super.key,
  });

  /// The error message to display.
  final String message;

  /// The callback to invoke when the user wants to retry the application startup.
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: Theme.of(context).textTheme.headlineSmall),
            gapH16,
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
