import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gones_starter_kit/features/authentication/data/session_storage.dart';
import 'package:gones_starter_kit/features/authentication/domain/app_user.dart';
import 'package:gones_starter_kit/routing/app_startup.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_session.g.dart';
part 'auth_session.freezed.dart';

/// This is the provider for the AuthSession class.
@Riverpod(keepAlive: true)
class AuthSession extends _$AuthSession {
  @override
  AuthSessionState? build() {
    return ref.watch(
      appStartupProvider.select((data) => data.requireValue.authSession),
    );
  }

  /// Updates the authentication session with the provided [session].
  ///
  /// This method writes the [session] to the session storage and updates the state
  /// of the authentication session.
  ///
  /// Throws an exception if there is an error while writing the session to the storage.
  Future<void> update(AuthSessionState session) async {
    final sessionStorage = ref.read(sessionStorageProvider);
    await sessionStorage.write(session);
    state = session;
  }

  /// Deletes the authentication session.
  ///
  /// This method deletes the authentication session by calling the `delete` method
  /// of the `sessionStorage` object. It also sets the state to `null`.
  Future<void> delete() async {
    final sessionStorage = ref.read(sessionStorageProvider);
    await sessionStorage.delete();
    state = null;
  }
}

/// This is a freezed class that generates the AuthSessionState class.
@freezed
class AuthSessionState with _$AuthSessionState {
  /// This is a data class that represents the state of the authentication session.
  const factory AuthSessionState({
    required AppUser user,
  }) = _AuthSessionState;

  /// This is a factory constructor that creates an AuthSessionState object from a JSON object.
  factory AuthSessionState.fromJson(Map<String, dynamic> json) => _$AuthSessionStateFromJson(json);
}
