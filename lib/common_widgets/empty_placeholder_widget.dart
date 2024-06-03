import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gones_starter_kit/common_widgets/primary_button.dart';
import 'package:gones_starter_kit/constants/app_sizes.dart';
import 'package:gones_starter_kit/routing/app_router.dart';

/// Placeholder widget showing a message and CTA to go back to the home screen.
class EmptyPlaceholderWidget extends ConsumerWidget {
  /// Creates a new instance of the [EmptyPlaceholderWidget] widget.
  const EmptyPlaceholderWidget({
    required this.message,
    super.key,
  });

  /// The message to display.
  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            gapH32,
            PrimaryButton(
              onPressed: () {
                context.goNamed(AppRouter.home.name);
              },
              text: 'Go Home',
            ),
          ],
        ),
      ),
    );
  }
}
