import 'package:flutter/widgets.dart';
import 'package:{{app_name}}/localization/strings_en.dart';
import 'package:{{app_name}}/localization/strings_fr.dart';

/// Abstract base class for all app strings.
abstract class AppStrings {
  /// Returns the [AppStrings] implementation for the current locale.
  /// Falls back to English if no localization ancestor is found.
  static AppStrings of(BuildContext context) {
    try {
      final locale = Localizations.localeOf(context);
      if (locale.languageCode == 'fr') return AppStringsFr();
    } catch (_) {
      // No localization ancestor — use English default
    }
    return AppStringsEn();
  }

  // Auth
  String get welcomeBack;
  String get signInSubtitle;
  String get email;
  String get emailHint;
  String get password;
  String get signIn;
  String get createAccount;
  String get createAccountTitle;
  String get createAccountSubtitle;
  String get signUp;
  String get alreadyHaveAccount;

  // Home
  String get homeTitle;
  String get counterLabel;

  // Account
  String get accountTitle;
  String get userInfo;
  String get changePassword;
  String get currentPassword;
  String get newPassword;
  String get confirmPassword;
  String get save;
  String get signOut;
  String get deleteAccount;
  String get deleteAccountConfirmTitle;
  String get deleteAccountConfirmMessage;
  String get cancel;
  String get confirm;

  // Errors
  String get emailEmpty;
  String get emailInvalid;
  String get passwordEmpty;
  String get passwordTooShort;
  String get passwordsDoNotMatch;
}
