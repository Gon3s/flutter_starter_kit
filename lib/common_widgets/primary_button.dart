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
    this.height = Sizes.p48,
    this.width,
    this.onPressed,
  });

  /// The text to display on the button.
  final String text;

  /// If true, a loading indicator will be displayed instead of the text.
  final bool isLoading;

  /// The height of the button.
  /// Default is 48.
  final double height;

  /// The width of the button.
  /// Default is null.
  final double? width;

  /// Callback to be called when the button is pressed.
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        child: isLoading
            ? const CircularProgressIndicator()
            : Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
              ),
      ),
    );
  }
}
