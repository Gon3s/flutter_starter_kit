/// StringValidator is a mixin that defines a single method isValid() that returns a boolean value.
// ignore: one_member_abstracts
abstract class StringValidator {
  /// isValid() is a method that takes a String value and returns a boolean value.
  bool isValid(String value);
}

/// A class that implements the StringValidator mixin.
class RegexValidator implements StringValidator {
  /// RegexValidator is a class that implements the StringValidator mixin.
  RegexValidator({required this.regexSource});

  /// The regex pattern.
  final String regexSource;

  @override
  bool isValid(String value) {
    try {
      // https://regex101.com/
      final regex = RegExp(regexSource);
      final Iterable<Match> matches = regex.allMatches(value);
      for (final match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // Invalid regex
      assert(false, e.toString());
      return true;
    }
  }
}

/// A validator that checks if a string matches the email format.
///
/// This validator extends the [RegexValidator] class and uses a regular expression
/// to validate if a string is a valid email address. The regular expression used
/// is `r'^\S+@\S+\.\S+$'`.
class EmailRegexValidator extends RegexValidator {
  ///
  EmailRegexValidator() : super(regexSource: r'^\S+@\S+\.\S+$');
}

/// A validator that checks if a string is non-empty.
class NonEmptyStringValidator extends StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

/// A validator that checks if a string has a minimum length.
class MinLengthStringValidator extends StringValidator {
  /// Creates a [MinLengthStringValidator] with the specified [minLength].
  MinLengthStringValidator(this.minLength);

  /// The minimum length required for the string to be considered valid.
  final int minLength;

  @override
  bool isValid(String value) {
    return value.length >= minLength;
  }
}
