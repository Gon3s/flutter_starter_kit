import 'dart:async';

import 'package:gones_starter_kit/exceptions/app_exception.dart';
import 'package:gones_starter_kit/features/authentication/data/auth_session.dart';
import 'package:gones_starter_kit/features/authentication/domain/app_user.dart';
import 'package:gones_starter_kit/features/authentication/domain/auth_repository.dart';
import 'package:gones_starter_kit/features/authentication/domain/fake_app_user.dart';
import 'package:gones_starter_kit/utils/delay.dart';
import 'package:gones_starter_kit/utils/in_memory_state.dart';

/// Fake implementation of the authentication repository.
class FakeAuthRepository extends AuthRepository {
  /// Creates a new instance of the [FakeAuthRepository] class.
  FakeAuthRepository({this.addDelay = true});

  /// Boolean flag for simulate a delay
  final bool addDelay;

  final _authState = InMemoryStore<AppUser?>(null);

  /// List of fake users.
  final List<FakeAppUser> fakeUsers = [
    FakeAppUser(
      uid: 'test@test.com'.split('').reversed.join(),
      email: 'test@test.com',
      password: 'P@ssword',
    ),
  ];

  @override
  Stream<AppUser?> authStateChanges() => _authState.stream;

  @override
  AppUser? get currentUser => _authState.value;

  @override
  void dispose() {
    _authState.close();
  }

  @override
  Future<void> signInWithEmailAndPassword(AuthParams params) async {
    await delay(addDelay: addDelay);

    final user = fakeUsers.firstWhere(
      (u) => u.email == params.email,
      orElse: () => throw UserNotFoundException(),
    );

    if (user.password != params.password) {
      throw WrongPasswordException();
    }

    _authState.value = AppUser(uid: user.uid, email: user.email);
  }

  @override
  Future<void> signUpWithEmailAndPassword(AuthParams params) async {
    await delay(addDelay: addDelay);

    // Check if the user already exists
    if (fakeUsers.any((u) => u.email == params.email)) {
      throw EmailAlreadyExistsException();
    }

    // minimum password length requirement
    if (params.password.length < 8) {
      throw WeakPasswordException();
    }

    final user = FakeAppUser(
      uid: params.email.split('').reversed.join(),
      email: params.email,
      password: params.password,
    );

    fakeUsers.add(user);

    _authState.value = AppUser(uid: user.uid, email: user.email);
  }

  @override
  Future<void> signOut() async {
    await delay(addDelay: addDelay);

    _authState.value = null;
  }

  @override
  Future<void> restoreSession(AuthSessionState session) async {
    _authState.value = session.user;
  }
}
