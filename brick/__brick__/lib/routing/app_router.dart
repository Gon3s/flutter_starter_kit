import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
{{#avec_auth}}
import 'package:{{app_name}}/features/authentication/domain/auth_repository.dart';
import 'package:{{app_name}}/features/authentication/presentation/account/account_screen.dart';
import 'package:{{app_name}}/features/authentication/presentation/sign_in/sign_in_screen.dart';
import 'package:{{app_name}}/features/authentication/presentation/sign_up/sign_up_screen.dart';
{{/avec_auth}}
import 'package:{{app_name}}/features/home/presentation/home_screen.dart';
import 'package:{{app_name}}/routing/app_startup.dart';
{{#avec_auth}}
import 'package:{{app_name}}/routing/go_router_refresh_stream.dart';
{{/avec_auth}}
import 'package:{{app_name}}/routing/not_found_screen.dart';
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

  {{#avec_auth}}
  /// The sign in screen.
  login,

  /// The sign up screen.
  signUp,

  /// The account screen.
  account,
  {{/avec_auth}}
}

/// The application router provider.
@riverpod
GoRouter goRouter(Ref ref) {
  final appStartupState = ref.watch(appStartupProvider);
  {{#avec_auth}}
  final authRepository = ref.watch(authRepositoryProvider);
  {{/avec_auth}}

  return GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      if (appStartupState.isLoading || appStartupState.hasError) {
        return '/${AppRouter.startup.name}';
      }
      {{#avec_auth}}
      final path = state.uri.path;
      final isLoggedIn = authRepository.currentUser != null;
      if (isLoggedIn) {
        if (path == '/${AppRouter.login.name}' || path == '/${AppRouter.signUp.name}') return '/';
      } else {
        if (path != '/${AppRouter.login.name}' && path != '/${AppRouter.signUp.name}') {
          return '/${AppRouter.login.name}';
        }
      }
      {{/avec_auth}}
      return null;
    },
    {{#avec_auth}}
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    {{/avec_auth}}
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
        {{#avec_auth}}
        routes: [
          GoRoute(
            path: AppRouter.account.name,
            name: AppRouter.account.name,
            pageBuilder: (context, state) => const NoTransitionPage(child: AccountScreen()),
          ),
        ],
        {{/avec_auth}}
      ),
      {{#avec_auth}}
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
      {{/avec_auth}}
    ],
    errorPageBuilder: (context, state) => const NoTransitionPage(child: NotFoundScreen()),
  );
}
