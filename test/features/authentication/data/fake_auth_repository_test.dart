import 'package:flutter_test/flutter_test.dart';
import 'package:gones_starter_kit/exceptions/app_exception.dart';
import 'package:gones_starter_kit/features/authentication/data/auth_session.dart';
import 'package:gones_starter_kit/features/authentication/data/fake_auth_repository.dart';
import 'package:gones_starter_kit/features/authentication/domain/app_user.dart';
import 'package:gones_starter_kit/features/authentication/domain/fake_app_user.dart';

void main() {
  // Initialization
  const testEmail = 'fake@test.com';
  const testPassword = 'testPassword';
  const wrongTestPassword = 'short';
  final testUser = AppUser(
    uid: testEmail.split('').reversed.join(),
    email: testEmail,
  );
  FakeAuthRepository makeFakeAuthRepository() {
    return FakeAuthRepository(
      addDelay: false,
    );
  }

  test('currentUser is null', () {
    final authRepository = makeFakeAuthRepository();
    addTearDown(authRepository.dispose);

    expect(authRepository.currentUser, null);
    expect(authRepository.authStateChanges(), emits(null));
  });

  test('sign in throw when user not found', () async {
    final authRepository = makeFakeAuthRepository();
    addTearDown(authRepository.dispose);

    await expectLater(
      () => authRepository.signInWithEmailAndPassword(
        (
          email: testEmail,
          password: testPassword,
        ),
      ),
      throwsA(isA<UserNotFoundException>()),
    );
    expect(authRepository.currentUser, null);
    expect(authRepository.authStateChanges(), emits(null));
  });

  test('sign in success change currentUser', () async {
    final authRepository = makeFakeAuthRepository();
    addTearDown(authRepository.dispose);

    authRepository.fakeUsers.add(
      FakeAppUser(
        uid: testUser.uid,
        email: testUser.email,
        password: testPassword,
      ),
    );

    await authRepository.signInWithEmailAndPassword(
      (
        email: testEmail,
        password: testPassword,
      ),
    );
    expect(authRepository.currentUser, testUser);
    expect(authRepository.authStateChanges(), emits(testUser));
  });

  test('sign in with wrong password throw WrongPasswordException', () async {
    final authRepository = makeFakeAuthRepository();
    addTearDown(authRepository.dispose);

    authRepository.fakeUsers.add(
      FakeAppUser(
        uid: testUser.uid,
        email: testUser.email,
        password: testPassword,
      ),
    );

    await expectLater(
      () => authRepository.signInWithEmailAndPassword(
        (
          email: testEmail,
          password: wrongTestPassword,
        ),
      ),
      throwsA(isA<WrongPasswordException>()),
    );
    expect(authRepository.currentUser, null);
    expect(authRepository.authStateChanges(), emits(null));
  });

  test('sign up with email already exists throw EmailAlreadyExistsException', () async {
    final authRepository = makeFakeAuthRepository();
    addTearDown(authRepository.dispose);

    authRepository.fakeUsers.add(
      FakeAppUser(
        uid: testUser.uid,
        email: testUser.email,
        password: testPassword,
      ),
    );

    await expectLater(
      () => authRepository.signUpWithEmailAndPassword(
        (
          email: testEmail,
          password: testPassword,
        ),
      ),
      throwsA(isA<EmailAlreadyExistsException>()),
    );

    expect(authRepository.currentUser, null);
    expect(authRepository.authStateChanges(), emits(null));
  });

  test('sign up with password too short throw WrongPasswordExeption', () async {
    final authRepository = makeFakeAuthRepository();
    addTearDown(authRepository.dispose);

    await expectLater(
      () => authRepository.signUpWithEmailAndPassword(
        (
          email: testEmail,
          password: wrongTestPassword,
        ),
      ),
      throwsA(isA<WeakPasswordException>()),
    );

    expect(authRepository.currentUser, null);
    expect(authRepository.authStateChanges(), emits(null));
  });

  test('sign up success change currentUser', () async {
    final authRepository = makeFakeAuthRepository();
    addTearDown(authRepository.dispose);

    await authRepository.signUpWithEmailAndPassword(
      (
        email: testEmail,
        password: testPassword,
      ),
    );
    expect(authRepository.currentUser, testUser);
    expect(authRepository.authStateChanges(), emits(testUser));
  });

  test('currentUser is null after sign out', () async {
    final authRepository = makeFakeAuthRepository();
    addTearDown(authRepository.dispose);

    await authRepository.signUpWithEmailAndPassword(
      (
        email: testEmail,
        password: testPassword,
      ),
    );
    expect(authRepository.currentUser, testUser);
    expect(authRepository.authStateChanges(), emits(testUser));

    await authRepository.signOut();
    expect(authRepository.currentUser, null);
    expect(authRepository.authStateChanges(), emits(null));
  });

  test('restoreSession change current user and emit changes', () async {
    final authRepository = makeFakeAuthRepository();
    addTearDown(authRepository.dispose);

    final authSession = AuthSessionState(user: testUser);
    await authRepository.restoreSession(authSession);

    expect(authRepository.currentUser, testUser);
    expect(authRepository.authStateChanges(), emits(testUser));
  });
}
