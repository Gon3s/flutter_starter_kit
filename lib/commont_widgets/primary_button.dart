import 'package:flutter/material.dart';
import 'package:gones_starter_kit/constants/app_sizes.dart';

/// Primary button based on [ElevatedButton].
/// Useful for CTAs in the app.
/// @param text - text to display on the button.
/// @param isLoading - if true, a loading indicator will be displayed instead of
/// the text.
/// @param onPressed - callback to be called when the button is pressed.
class PrimaryButton extends StatelessWidget {
  ///
  const PrimaryButton({
    required this.text,
    super.key,
    this.isLoading = false,
    this.onPressed,
  });

  /// The text to display on the button.
  final String text;

  /// If true, a loading indicator will be displayed instead of the text.
  final bool isLoading;

  /// Callback to be called when the button is pressed.
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizes.p48,
      child: ElevatedButton(
        onPressed: onPressed,
        child: isLoading
            ? const CircularProgressIndicator()
            : Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
              ),
      ),
    );
  }
}
