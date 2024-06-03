import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';

@freezed

/// Simple class representing a user of the app.
class AppUser with _$AppUser {
  /// Creates a new instance of the [AppUser] class.
  const factory AppUser({
    required String uid,
    required String email,
  }) = _AppUser;
}
