import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// @source: https://codewithandrea.com/articles/loading-error-states-state-notifier-async-value/
/// Bonus: define AsyncValue<void> as a typedef that we can
/// reuse across multiple widgets and state notifiers
typedef VoidAsyncValue = AsyncValue<void>;

/// Extension methods for AsyncValue<void>
extension AsyncValueUI on VoidAsyncValue {
  /// Returns true if the state is AsyncLoading
  bool get isLoading => this is AsyncLoading<void>;

  /// Show a snack bar with an error message if the state is AsyncError
  /// Hide any existing snack bars before showing the new one
  void showSnackBarOnError(BuildContext context) => whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(error.toString())),
            );
        },
      );
}
