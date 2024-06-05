import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

/// Simple class representing a user of the app.
@freezed
class AppUser with _$AppUser {
  /// Creates a new instance of the [AppUser] class.
  const factory AppUser({
    required String uid,
    required String email,
  }) = _AppUser;

  /// Creates a new instance of the [AppUser] class from a JSON object.
  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);
}
