@Timeout(Duration(milliseconds: 500))
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gones_starter_kit/features/authentication/data/session_storage.dart';
import 'package:gones_starter_kit/features/authentication/domain/auth_repository.dart';
import 'package:gones_starter_kit/features/authentication/presentation/account/account_controller.dart';
import 'package:gones_starter_kit/utils/notification_service.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  ProviderContainer makeProviderContainer(
    MockAuthRepository authRepository,
    MockSessionStorage sessionStorage,
    MockNotificationService notificationService,
  ) {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        sessionStorageProvider.overrideWithValue(sessionStorage),
        notificationServiceProvider.overrideWithValue(notificationService),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUpAll(() {
    registerFallbackValue(const AsyncLoading<void>());
  });

  test('Initial state is AsyncData', () {
    // setup
    final authRepository = MockAuthRepository();
    final sessionStorage = MockSessionStorage();
    final notificationService = MockNotificationService();
    final container = makeProviderContainer(
      authRepository,
      sessionStorage,
      notificationService,
    );
    final listener = Listener<AsyncValue<void>>();
    container.listen(
      accountControllerProvider,
      listener.call,
      fireImmediately: true,
    );

    verify(
      () => listener(null, const AsyncData<void>(null)),
    );

    verifyNoMoreInteractions(listener);
    verifyNever(authRepository.signOut);
    verifyNever(sessionStorage.delete);
    verifyNever(notificationService.unregisterDevice);
  });

  test('signOut success', () async {
    // setup
    final authRepository = MockAuthRepository();
    final sessionStorage = MockSessionStorage();
    final notificationService = MockNotificationService();
    when(authRepository.signOut).thenAnswer((_) => Future.value());
    when(sessionStorage.delete).thenAnswer((_) => Future.value());
    when(notificationService.unregisterDevice).thenAnswer((_) => Future.value());
    final container = makeProviderContainer(
      authRepository,
      sessionStorage,
      notificationService,
    );
    final listener = Listener<AsyncValue<void>>();
    container.listen(
      accountControllerProvider,
      listener.call,
      fireImmediately: true,
    );

    const data = AsyncData<void>(null);

    verify(
      () => listener(null, data),
    );

    final controller = container.read(accountControllerProvider.notifier);
    await controller.signOut();

    // verify
    verifyInOrder([
      () => listener(
            data,
            any(that: isA<AsyncLoading<void>>()),
          ),
      () => listener(
            any(that: isA<AsyncLoading<void>>()),
            data,
          ),
    ]);

    verifyNoMoreInteractions(listener);
    verify(authRepository.signOut).called(1);
    verify(sessionStorage.delete).called(1);
    verify(notificationService.unregisterDevice).called(1);
  });
}
