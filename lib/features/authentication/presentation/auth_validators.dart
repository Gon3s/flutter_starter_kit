import 'package:gones_starter_kit/utils/string_validator.dart';

/// Mixin for authentication validators
mixin AuthValidators {
  /// Email validator
  final emailValidator = EmailRegexValidator();

  /// Password validator
  final passwordValidator = MinLengthStringValidator(6);

  /// Check if email is valid
  bool canSubmitEmail(String email) {
    return emailValidator.isValid(email);
  }

  /// Check if password is valid
  bool canSubmitPassword(String password) {
    return passwordValidator.isValid(password);
  }

  /// Validator for email
  String? validateEmail(String email) {
    if (email.isEmpty) {
      return "L'email ne peut pas être vide";
    }
    if (!canSubmitEmail(email)) {
      return "L'email n'est pas valide";
    }
    return null;
  }

  /// Validator for password
  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Le mot de passe ne peut pas être vide';
    }
    return null;
  }
}
