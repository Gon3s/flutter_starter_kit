import 'package:gones_starter_kit/features/authentication/data/firebase_auth_repository.dart';
import 'package:gones_starter_kit/features/authentication/domain/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'change_password_controller.g.dart';

@riverpod

/// Controller for the change password feature.
class ChangePasswordController extends _$ChangePasswordController {
  @override
  FutureOr<void> build() {}

  /// Re-authenticates then updates the password.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final repo = ref.read(authRepositoryProvider) as FirebaseAuthRepository;
    final email = repo.currentUser?.email ?? '';

    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(() async {
      await repo.reauthenticate(email, currentPassword);
      await repo.updatePassword(newPassword);
    });
  }
}
