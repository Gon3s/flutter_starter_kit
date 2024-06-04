import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gones_starter_kit/constants/app_sizes.dart';
import 'package:gones_starter_kit/routing/app_router.dart';

/// The main application widget.
class MyApp extends ConsumerWidget {
  /// Creates a new instance of the [MyApp] widget.
  const MyApp({super.key});

  /// The primary color of the application.
  static const primaryColor = Colors.green;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: goRouter,
      theme: ThemeData(
        colorSchemeSeed: primaryColor,
        unselectedWidgetColor: Colors.grey,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
        ),
        scaffoldBackgroundColor: Colors.grey[200],
        dividerColor: Colors.grey[400],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
        ),
        //! Input Decoration
        inputDecorationTheme: InputDecorationTheme(
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Sizes.p8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Sizes.p8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Sizes.p8),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Sizes.p8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Sizes.p8),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
