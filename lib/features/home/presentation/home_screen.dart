import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gones_starter_kit/features/authentication/presentation/account/account_controller.dart';
import 'package:gones_starter_kit/features/home/presentation/counter_controller.dart';

/// The home screen of the application.
class HomeScreen extends ConsumerWidget {
  /// Creates a new instance of the [HomeScreen] widget.
  const HomeScreen({required this.title, super.key});

  /// The title of the home screen.
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountController = ref.watch(accountControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: accountController.isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  )
                : const Icon(Icons.logout_outlined),
            onPressed: () =>
                accountController.isLoading ? null : ref.read(accountControllerProvider.notifier).signOut(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '${ref.watch(counterControllerProvider)}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterControllerProvider.notifier).increment(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
