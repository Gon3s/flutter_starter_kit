import 'package:firebase_auth/firebase_auth.dart';
import 'package:{{app_name}}/exceptions/app_exception.dart';
import 'package:{{app_name}}/features/authentication/data/auth_session.dart';
import 'package:{{app_name}}/features/authentication/domain/app_user.dart';
import 'package:{{app_name}}/features/authentication/domain/auth_repository.dart';

/// Firebase implementation of [AuthRepository].
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  @override
  Stream<AppUser?> authStateChanges() => _firebaseAuth.authStateChanges().map(_toAppUser);

  @override
  AppUser? get currentUser => _toAppUser(_firebaseAuth.currentUser);

  @override
  Future<void> signInWithEmailAndPassword(AuthParams params) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<void> signUpWithEmailAndPassword(AuthParams params) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<void> signOut() async => _firebaseAuth.signOut();

  @override
  Future<void> restoreSession(AuthSessionState session) async {}

  @override
  void dispose() {}

  /// Re-authenticates the current user before sensitive operations.
  Future<void> reauthenticate(String email, String password) async {
    try {
      final credential = EmailAuthProvider.credential(email: email, password: password);
      await _firebaseAuth.currentUser?.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  /// Updates the current user's password. Call [reauthenticate] first.
  Future<void> updatePassword(String newPassword) async {
    try {
      await _firebaseAuth.currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  /// Deletes the current user account.
  Future<void> deleteAccount() async {
    try {
      await _firebaseAuth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  AppUser? _toAppUser(User? user) {
    if (user == null) return null;
    return AppUser(uid: user.uid, email: user.email ?? '');
  }

  AppException _mapException(FirebaseAuthException e) {
    return switch (e.code) {
      'user-not-found' || 'invalid-email' || 'invalid-credential' => UserNotFoundException(),
      'wrong-password' => WrongPasswordException(),
      'email-already-in-use' => EmailAlreadyExistsException(),
      'weak-password' => WeakPasswordException(),
      'requires-recent-login' => RequiresRecentLoginException(),
      _ => UnknownAuthException(e.message),
    };
  }
}
