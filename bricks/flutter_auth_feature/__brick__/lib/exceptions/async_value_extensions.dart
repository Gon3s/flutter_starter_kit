import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// @source: https://codewithandrea.com/articles/loading-error-states-state-notifier-async-value/
typedef VoidAsyncValue = AsyncValue<void>;

/// Extension methods for AsyncValue<void>.
/// Note: isLoading is now a native property of AsyncValue in Riverpod 3.x.
extension AsyncValueUI on VoidAsyncValue {
  /// Show a snack bar with an error message if the state is AsyncError.
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
