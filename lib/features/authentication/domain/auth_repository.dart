import 'package:gones_starter_kit/features/authentication/data/auth_session.dart';
import 'package:gones_starter_kit/features/authentication/data/fake_auth_repository.dart';
import 'package:gones_starter_kit/features/authentication/domain/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

/// Type definition for the sign in authentication parameters.
typedef AuthParams = ({String email, String password});

/// Contract for the authentication repository.
abstract class AuthRepository {
  /// Stream changes in the authentication state.
  Stream<AppUser?> authStateChanges();

  /// The current authenticated user or null if not authenticated.
  AppUser? get currentUser;

  /// Signs in the user with the given email and password.
  Future<void> signInWithEmailAndPassword(AuthParams params);

  /// Signs up the user with the given email and password.
  Future<void> signUpWithEmailAndPassword(AuthParams params);

  /// Signs out the current user.
  Future<void> signOut();

  /// Retrieves users session from the storage.
  Future<void> restoreSession(AuthSessionState session);

  /// Disposes of the resources used by the repository.
  void dispose();
}

/// Provide authentication repository.
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final auth = FakeAuthRepository();
  ref.onDispose(auth.dispose);
  return auth;
}
