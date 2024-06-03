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
  UserNotFoundException() : super('user_not_found', 'User not found.');
}

/// Exception thrown when the password is wrong.
class WrongPasswordException extends AppException {
  /// Creates a new instance of the [WrongPasswordException] class.
  WrongPasswordException() : super('wrong_password', 'Wrong password.');
}

/// Exception thrown when the email already exists.
class EmailAlreadyExistsException extends AppException {
  /// Creates a new instance of the [EmailAlreadyExistsException] class.
  EmailAlreadyExistsException() : super('email_already_exists', 'Email already exists.');
}

/// Exception thrown when the password is too short.
class WeakPasswordException extends AppException {
  /// Creates a new instance of the [WeakPasswordException] class.
  WeakPasswordException() : super('password_too_short', 'Password is too short.');
}
