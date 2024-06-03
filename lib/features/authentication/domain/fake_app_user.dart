import 'package:gones_starter_kit/features/authentication/domain/app_user.dart';

/// Fake user class used to simulate a user in the app.
class FakeAppUser {
  /// Creates a new instance of the [FakeAppUser] class.
  FakeAppUser({
    required String uid,
    required String email,
    required this.password,
  }) : _appUser = AppUser(uid: uid, email: email);

  /// The password of the user.
  final String password;

  /// The AppUser instance.
  final AppUser _appUser;

  /// Delegate uid to _appUser.
  String get uid => _appUser.uid;

  /// Delegate email to _appUser.
  String get email => _appUser.email;
}
