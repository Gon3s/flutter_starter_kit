import 'package:{{app_name}}/localization/app_strings.dart';

/// English strings.
class AppStringsEn implements AppStrings {
  @override
  String get welcomeBack => 'Welcome back';
  @override
  String get signInSubtitle => 'Sign in to your account';
  @override
  String get email => 'Email';
  @override
  String get emailHint => 'example@domain.com';
  @override
  String get password => 'Password';
  @override
  String get signIn => 'Sign in';
  @override
  String get createAccount => 'Create an account';
  @override
  String get createAccountTitle => 'Create an account';
  @override
  String get createAccountSubtitle => 'Join us today';
  @override
  String get signUp => 'Sign up';
  @override
  String get alreadyHaveAccount => 'Already have an account? Sign in';

  @override
  String get homeTitle => 'Home';
  @override
  String get counterLabel => 'You have pushed the button this many times:';

  @override
  String get accountTitle => 'My account';
  @override
  String get userInfo => 'Information';
  @override
  String get changePassword => 'Change password';
  @override
  String get currentPassword => 'Current password';
  @override
  String get newPassword => 'New password';
  @override
  String get confirmPassword => 'Confirm password';
  @override
  String get save => 'Save';
  @override
  String get signOut => 'Sign out';
  @override
  String get deleteAccount => 'Delete account';
  @override
  String get deleteAccountConfirmTitle => 'Delete account?';
  @override
  String get deleteAccountConfirmMessage =>
      'This action is irreversible. All your data will be permanently deleted.';
  @override
  String get cancel => 'Cancel';
  @override
  String get confirm => 'Confirm';

  @override
  String get emailEmpty => 'Email cannot be empty';
  @override
  String get emailInvalid => 'Email is not valid';
  @override
  String get passwordEmpty => 'Password cannot be empty';
  @override
  String get passwordTooShort => 'Password must be at least 8 characters';
  @override
  String get passwordsDoNotMatch => 'Passwords do not match';
}
