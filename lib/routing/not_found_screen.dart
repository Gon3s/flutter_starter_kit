import 'package:flutter/material.dart';
import 'package:gones_starter_kit/commont_widgets/empty_placeholder_widget.dart';
import 'package:gones_starter_kit/localization/string_hardcoded.dart';

/// Simple not found screen used for 404 errors (page not found on web)
class NotFoundScreen extends StatelessWidget {
  /// Creates a new instance of the [NotFoundScreen] widget.
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: EmptyPlaceholderWidget(
        message: '404 - Page not found!'.hardcoded,
      ),
    );
  }
}
