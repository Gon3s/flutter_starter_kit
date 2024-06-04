import 'package:gones_starter_kit/features/authentication/domain/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_controller.g.dart';

@riverpod

/// Controller for the sign in screen
class SignInController extends _$SignInController {
  @override
  FutureOr<void> build() {}

  /// Submit the sign in form
  Future<void> submit({
    required String email,
    required String password,
  }) async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(
      () => authRepository.signInWithEmailAndPassword(
        (
          email: email,
          password: password,
        ),
      ),
    );
  }
}
