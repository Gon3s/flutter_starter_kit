import 'package:{{app_name}}/features/authentication/data/auth_session.dart';
import 'package:{{app_name}}/features/authentication/data/session_storage.dart';
import 'package:{{app_name}}/features/authentication/domain/auth_repository.dart';
import 'package:{{app_name}}/utils/notification_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_controller.g.dart';

@riverpod

/// Controller for the sign up screen.
class SignUpController extends _$SignUpController {
  @override
  FutureOr<void> build() {}

  /// Submit the sign up form.
  Future<void> submit({
    required String email,
    required String password,
  }) async {
    final authRepository = ref.read(authRepositoryProvider);
    final sessionStorage = ref.read(sessionStorageProvider);
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(() async {
      await authRepository.signUpWithEmailAndPassword((email: email, password: password));
      await sessionStorage.write(AuthSessionState(user: authRepository.currentUser!));
      await ref.read(notificationServiceProvider).registerDevice();
    });
  }
}
