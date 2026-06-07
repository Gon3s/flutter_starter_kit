import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{app_name}}/features/home/presentation/counter_controller.dart';
import 'package:{{app_name}}/localization/app_strings.dart';
{{#avec_auth}}
import 'package:{{app_name}}/routing/app_router.dart';
{{/avec_auth}}

/// The home screen of the application.
class HomeScreen extends ConsumerWidget {
  /// Creates a new instance of the [HomeScreen] widget.
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.homeTitle),
        {{#avec_auth}}
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => ref.read(goRouterProvider).goNamed(AppRouter.account.name),
          ),
        ],
        {{/avec_auth}}
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(s.counterLabel),
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
