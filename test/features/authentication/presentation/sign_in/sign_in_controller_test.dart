import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gones_starter_kit/features/authentication/domain/auth_repository.dart';
import 'package:gones_starter_kit/features/authentication/presentation/sign_in/sign_in_controller.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  const testEmail = 'test@test.com';
  const testPassword = 'testPassword';

  ProviderContainer makeProviderContainer(MockAuthRepository authRepository) {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUpAll(() {
    registerFallbackValue(const AsyncLoading<void>());
  });

  test('submit sign in form success', () async {
    // setup
    final authRepository = MockAuthRepository();
    final container = makeProviderContainer(authRepository);

    when(
      () => authRepository.signInWithEmailAndPassword(
        (
          email: testEmail,
          password: testPassword,
        ),
      ),
    ).thenAnswer((_) => Future.value());
    final listener = Listener<AsyncValue<void>>();
    container.listen(
      signInControllerProvider,
      listener.call,
      fireImmediately: true,
    );

    const data = AsyncData<void>(null);
    verify(() => listener(null, data));

    // run
    final controller = container.read(signInControllerProvider.notifier);
    await controller.submit(
      email: testEmail,
      password: testPassword,
    );

    // verify
    verifyInOrder([
      // loading state
      () => listener(data, any(that: isA<AsyncLoading<void>>())),
      // data when complete
      () => listener(any(that: isA<AsyncLoading<void>>()), data),
    ]);
    verifyNoMoreInteractions(listener);
  });

  test('submit sign in form failed', () async {
    // setup
    final authRepository = MockAuthRepository();
    final exception = Exception('error');
    final container = makeProviderContainer(authRepository);

    when(
      () => authRepository.signInWithEmailAndPassword(
        (
          email: testEmail,
          password: testPassword,
        ),
      ),
    ).thenThrow(exception);
    final listener = Listener<AsyncValue<void>>();
    container.listen(
      signInControllerProvider,
      listener.call,
      fireImmediately: true,
    );

    const data = AsyncData<void>(null);
    verify(() => listener(null, data));

    // run
    final controller = container.read(signInControllerProvider.notifier);
    await controller.submit(
      email: testEmail,
      password: testPassword,
    );

    // verify
    verifyInOrder([
      // loading state
      () => listener(data, any(that: isA<AsyncLoading<void>>())),
      // data when complete
      () => listener(
            any(that: isA<AsyncLoading<void>>()),
            any(that: isA<AsyncError<void>>()),
          ),
    ]);
    verifyNoMoreInteractions(listener);
  });
}
