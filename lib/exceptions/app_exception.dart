/// Base class for all exceptions thrown by the app.
sealed class AppException implements Exception {
  AppException(this.code, this.message);

  /// A code that represents the exception.
  final String code;

  /// A message that describes the exception.
  final String message;

  @override
  String toString() => message;
}

/// Exception thrown when the user does not exist.
class UserNotFoundException extends AppException {
  /// Creates a new instance of the [UserNotFoundException] class.
  UserNotFoundException() : super('user_not_found', 'Aucun compte trouvé pour cet email.');
}

/// Exception thrown when the password is wrong.
class WrongPasswordException extends AppException {
  /// Creates a new instance of the [WrongPasswordException] class.
  WrongPasswordException() : super('wrong_password', 'Mot de passe incorrect.');
}

/// Exception thrown when the email already exists.
class EmailAlreadyExistsException extends AppException {
  /// Creates a new instance of the [EmailAlreadyExistsException] class.
  EmailAlreadyExistsException() : super('email_already_exists', 'Un compte existe déjà avec cet email.');
}

/// Exception thrown when the password is too short.
class WeakPasswordException extends AppException {
  /// Creates a new instance of the [WeakPasswordException] class.
  WeakPasswordException() : super('weak_password', 'Le mot de passe est trop faible (8 caractères minimum).');
}

/// Exception thrown when the user needs to re-authenticate before this operation.
class RequiresRecentLoginException extends AppException {
  /// Creates a new instance of the [RequiresRecentLoginException] class.
  RequiresRecentLoginException()
      : super('requires_recent_login', 'Veuillez vous reconnecter pour effectuer cette action.');
}

/// Exception thrown when an unknown auth error occurs.
class UnknownAuthException extends AppException {
  /// Creates a new instance of the [UnknownAuthException] class.
  UnknownAuthException([String? detail])
      : super('unknown_auth_error', detail ?? 'Une erreur est survenue. Veuillez réessayer.');
}
