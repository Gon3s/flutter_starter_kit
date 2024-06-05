import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gones_starter_kit/db/secure_storage.dart';
import 'package:gones_starter_kit/features/authentication/data/auth_session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_storage.g.dart';

@Riverpod(keepAlive: true)

/// This is the provider for the SessionStorage class.
SessionStorage sessionStorage(SessionStorageRef ref) {
  return SessionStorage(ref);
}

/// A class that provides methods for reading, writing, and deleting session data.
class SessionStorage {
  ///
  SessionStorage(this._ref);

  final SessionStorageRef _ref;

  FlutterSecureStorage get _storage => _ref.read(secureStorageProvider);

  /// Reads the session data from the storage and returns it as an [AuthSessionState] object.
  /// Returns `null` if no session data is found.
  Future<AuthSessionState?> read() async {
    final string = await _storage.read(key: _kSessionStorageKey);
    if (string != null) {
      return AuthSessionState.fromJson(
        jsonDecode(string) as Map<String, dynamic>,
      );
    }
    return null;
  }

  /// Writes the given [session] data to the storage.
  Future<void> write(AuthSessionState session) async {
    await _storage.write(
      key: _kSessionStorageKey,
      value: jsonEncode(
        session.toJson(),
      ),
    );
  }

  /// Deletes the session data from the storage.
  Future<void> delete() async {
    await _storage.delete(key: _kSessionStorageKey);
  }
}

const _kSessionStorageKey = 'userSession';
