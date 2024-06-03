import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        // inputDecorationTheme: InputDecorationTheme(
        //   errorMaxLines: 3,
        //   // errorStyle: AppStyles.textStyleError,
        //   // prefixIconColor: Theme.of(context).colorScheme.primary,
        //   // suffixIconColor: Theme.of(context).colorScheme.primary,
        //   // hintStyle: AppStyles.hintTextStyle,
        //   filled: true,
        //   fillColor: Theme.of(context).colorScheme.surface,
        //   disabledBorder: OutlineInputBorder(
        //     borderSide: BorderSide(
        //       color: Theme.of(context).colorScheme.,
        //     ),
        //     borderRadius: BorderRadius.circular(AppValues.textFieldRadius),
        //   ),
        //   enabledBorder: OutlineInputBorder(
        //     borderSide: const BorderSide(
        //       color: AppColors.black20,
        //     ),
        //     borderRadius: BorderRadius.circular(AppValues.textFieldRadius),
        //   ),
        //   focusedBorder: OutlineInputBorder(
        //     borderSide: const BorderSide(
        //       color: AppColors.darkBlue,
        //     ),
        //     borderRadius: BorderRadius.circular(AppValues.textFieldRadius),
        //   ),
        //   errorBorder: OutlineInputBorder(
        //     borderSide: const BorderSide(
        //       color: AppColors.backgroundCriticalStatus,
        //     ),
        //     borderRadius: BorderRadius.circular(AppValues.textFieldRadius),
        //   ),
        //   focusedErrorBorder: OutlineInputBorder(
        //     borderSide: const BorderSide(
        //       color: AppColors.black50,
        //     ),
        //     borderRadius: BorderRadius.circular(AppValues.textFieldRadius),
        //   ),
        //   contentPadding: const EdgeInsets.all(AppValues.defaultPadding),
        // ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
