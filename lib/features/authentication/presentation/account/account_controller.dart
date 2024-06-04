import 'package:gones_starter_kit/features/authentication/domain/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_controller.g.dart';

@riverpod

/// The controller class for the account feature.
/// This class extends the generated `_$AccountController` class.
class AccountController extends _$AccountController {
  @override
  FutureOr<void> build() {}

  /// Signs out the user.
  /// This method sets the state to `AsyncLoading` and then calls the `signOut` method of the `authRepository`.
  /// The result of the `signOut` method is assigned to the `state` variable.
  Future<void> signOut() async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(authRepository.signOut);
  }
}
