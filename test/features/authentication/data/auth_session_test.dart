@Timeout(Duration(milliseconds: 500))
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gones_starter_kit/features/authentication/data/auth_session.dart';
import 'package:gones_starter_kit/features/authentication/data/session_storage.dart';
import 'package:gones_starter_kit/features/authentication/domain/app_user.dart';
import 'package:gones_starter_kit/routing/app_startup.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
  const testEmail = 'fake@test.com';
  final testUser = AppUser(
    uid: testEmail.split('').reversed.join(),
    email: testEmail,
  );
  final testAuthSession = AuthSessionState(user: testUser);

  setUpAll(() {
    registerFallbackValue(testAuthSession);
  });

  test('Initial state is AsyncData null if authSession is null', () {
    final sessionStorage = MockSessionStorage();
    final container = ProviderContainer(
      overrides: [
        appStartupProvider.overrideWith(
          (ref) => const AppDependencies(
            authSession: null,
          ),
        ),
        sessionStorageProvider.overrideWithValue(sessionStorage),
      ],
    );
    addTearDown(container.dispose);
    final listener = Listener<AuthSessionState?>();
    container.listen<AuthSessionState?>(
      authSessionProvider,
      listener.call,
      fireImmediately: true,
    );

    verify(
      () => listener(
        null,
        null,
      ),
    );

    verifyNoMoreInteractions(listener);
    verifyNever(() => sessionStorage.write(any()));
    verifyNever(sessionStorage.delete);
  });

  test('Initial state is AsyncData if authSession is not null', () {
    final sessionStorage = MockSessionStorage();
    final container = ProviderContainer(
      overrides: [
        appStartupProvider.overrideWith(
          (ref) => AppDependencies(
            authSession: testAuthSession,
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    final listener = Listener<AuthSessionState?>();
    container.listen<AuthSessionState?>(
      authSessionProvider,
      listener.call,
      fireImmediately: true,
    );

    verify(
      () => listener(
        null,
        testAuthSession,
      ),
    );

    verifyNoMoreInteractions(listener);
    verifyNever(() => sessionStorage.write(any()));
    verifyNever(sessionStorage.delete);
  });

  test('State change when update session', () async {
    TestWidgetsFlutterBinding.ensureInitialized(); // Add this line

    final sessionStorage = MockSessionStorage();
    when(() => sessionStorage.write(testAuthSession)).thenAnswer((_) => Future.value());
    final container = ProviderContainer(
      overrides: [
        appStartupProvider.overrideWith(
          (ref) => const AppDependencies(
            authSession: null,
          ),
        ),
        sessionStorageProvider.overrideWithValue(sessionStorage),
      ],
    );
    addTearDown(container.dispose);
    final listener = Listener<AuthSessionState?>();
    container.listen<AuthSessionState?>(
      authSessionProvider,
      listener.call,
      fireImmediately: true,
    );

    verify(
      () => listener(
        null,
        null,
      ),
    );

    final controller = container.read(authSessionProvider.notifier);
    await controller.update(testAuthSession);

    verify(
      () => listener(
        null,
        testAuthSession,
      ),
    );

    verifyNoMoreInteractions(listener);
    verify(() => sessionStorage.write(testAuthSession)).called(1);
    verifyNever(sessionStorage.delete);
  });

  test('State change when delete session', () async {
    TestWidgetsFlutterBinding.ensureInitialized(); // Add this line

    final sessionStorage = MockSessionStorage();
    when(sessionStorage.delete).thenAnswer((_) => Future.value());
    final container = ProviderContainer(
      overrides: [
        appStartupProvider.overrideWith(
          (ref) => AppDependencies(
            authSession: testAuthSession,
          ),
        ),
        sessionStorageProvider.overrideWithValue(sessionStorage),
      ],
    );
    addTearDown(container.dispose);
    final listener = Listener<AuthSessionState?>();
    container.listen<AuthSessionState?>(
      authSessionProvider,
      listener.call,
      fireImmediately: true,
    );

    verify(
      () => listener(
        null,
        testAuthSession,
      ),
    );

    final controller = container.read(authSessionProvider.notifier);
    await controller.delete();

    verify(
      () => listener(
        testAuthSession,
        null,
      ),
    );

    verifyNoMoreInteractions(listener);
    verifyNever(() => sessionStorage.write(testAuthSession));
    verify(sessionStorage.delete).called(1);
  });
}
