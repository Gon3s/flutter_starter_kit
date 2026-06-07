import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gones_starter_kit/features/authentication/domain/auth_repository.dart';
import 'package:gones_starter_kit/features/authentication/presentation/account/account_screen.dart';
import 'package:gones_starter_kit/features/authentication/presentation/sign_in/sign_in_screen.dart';
import 'package:gones_starter_kit/features/authentication/presentation/sign_up/sign_up_screen.dart';
import 'package:gones_starter_kit/features/home/presentation/home_screen.dart';
import 'package:gones_starter_kit/routing/app_startup.dart';
import 'package:gones_starter_kit/routing/go_router_refresh_stream.dart';
import 'package:gones_starter_kit/routing/not_found_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// The application router.
enum AppRouter {
  /// The startup screen.
  startup,

  /// The home screen.
  home,

  /// The sign in screen.
  login,

  /// The sign up screen.
  signUp,

  /// The account screen.
  account,
}

/// The application router provider.
@riverpod
GoRouter goRouter(Ref ref) {
  final appStartupState = ref.watch(appStartupProvider);
  final authRepository = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final path = state.uri.path;
      final isLoggedIn = authRepository.currentUser != null;

      if (appStartupState.isLoading || appStartupState.hasError) {
        return '/${AppRouter.startup.name}';
      }

      if (isLoggedIn) {
        if (path == '/${AppRouter.login.name}' || path == '/${AppRouter.signUp.name}') {
          return '/';
        }
      } else {
        if (path != '/${AppRouter.login.name}' && path != '/${AppRouter.signUp.name}') {
          return '/${AppRouter.login.name}';
        }
      }

      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/${AppRouter.startup.name}',
        pageBuilder: (context, state) => NoTransitionPage(
          child: AppStartupWidget(onLoaded: (_) => const SizedBox.shrink()),
        ),
      ),
      GoRoute(
        path: '/',
        name: AppRouter.home.name,
        pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
        routes: [
          GoRoute(
            path: AppRouter.account.name,
            name: AppRouter.account.name,
            pageBuilder: (context, state) => const NoTransitionPage(child: AccountScreen()),
          ),
        ],
      ),
      GoRoute(
        path: '/${AppRouter.login.name}',
        name: AppRouter.login.name,
        pageBuilder: (context, state) => const NoTransitionPage(child: SignInScreen()),
      ),
      GoRoute(
        path: '/${AppRouter.signUp.name}',
        name: AppRouter.signUp.name,
        pageBuilder: (context, state) => const NoTransitionPage(child: SignUpScreen()),
      ),
    ],
    errorPageBuilder: (context, state) => const NoTransitionPage(child: NotFoundScreen()),
  );
}
