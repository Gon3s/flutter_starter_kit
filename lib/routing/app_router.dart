import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gones_starter_kit/features/home/presentation/home_screen.dart';
import 'package:gones_starter_kit/localization/string_hardcoded.dart';
import 'package:gones_starter_kit/routing/app_startup.dart';
import 'package:gones_starter_kit/routing/not_found_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// The application router.
enum AppRouter {
  /// The home screen.
  home,
}

/// The application router provider.
@riverpod
GoRouter goRouter(GoRouterRef ref) {
  // rebuild GoRouter when app startup state changes
  final appStartupState = ref.watch(appStartupProvider);

  return GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // If the app is still initializing, show the /startup route
      if (appStartupState.isLoading || appStartupState.hasError) {
        return '/startup';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/startup',
        pageBuilder: (context, state) => NoTransitionPage(
          child: AppStartupWidget(
            onLoaded: (_) => const SizedBox.shrink(),
          ),
        ),
      ),
      GoRoute(
        path: '/',
        name: AppRouter.home.name,
        pageBuilder: (context, state) => NoTransitionPage(
          child: HomeScreen(title: 'Flutter Demo Home Page'.hardcoded),
        ),
      ),
    ],
    errorPageBuilder: (context, state) => const NoTransitionPage(
      child: NotFoundScreen(),
    ),
  );
}
