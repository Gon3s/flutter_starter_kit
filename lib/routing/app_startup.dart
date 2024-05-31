import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gones_starter_kit/constants/app_sizes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_startup.g.dart';

@Riverpod(keepAlive: false)

/// The application startup provider.
Future<void> appStartup(AppStartupRef ref) async {
  await Future<void>.delayed(const Duration(seconds: 2));
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
