---
name: new-feature
description: Scaffold a new feature in this Flutter project following the feature-first architecture (data/domain/presentation) with Riverpod, Freezed, GoRouter and code generation. Use when the user asks to "add a feature", "create a screen", "scaffold", or build a new module in {{app_name}}.
---

# New feature scaffolding

Generate a new feature that respects this project's conventions. Ask the user
for the feature name (snake_case) if not provided.

## Steps

1. **Create the folder structure** under `lib/features/<feature>/`:
   ```
   data/
   domain/
   presentation/<screen>/
   ```

2. **Domain — model** (`lib/features/<feature>/domain/<model>.dart`).
   Use Freezed 3.x — the class MUST be `abstract`:
   ```dart
   import 'package:freezed_annotation/freezed_annotation.dart';

   part '<model>.freezed.dart';
   part '<model>.g.dart';

   @freezed
   abstract class <Model> with _$<Model> {
     const factory <Model>({required String id}) = _<Model>;
     factory <Model>.fromJson(Map<String, dynamic> json) =>
         _$<Model>FromJson(json);
   }
   ```

3. **Domain — repository contract** (`domain/<feature>_repository.dart`).
   Define an abstract class and a `@riverpod` provider returning it. Functional
   providers take a plain `Ref` (no `*Ref` aliases in Riverpod 3.x):
   ```dart
   import 'package:riverpod_annotation/riverpod_annotation.dart';

   part '<feature>_repository.g.dart';

   abstract class <Feature>Repository {
     Future<List<<Model>>> fetchAll();
   }

   @riverpod
   <Feature>Repository <feature>Repository(Ref ref) {
     return <Feature>RepositoryImpl();
   }
   ```

4. **Data — implementation** (`data/<feature>_repository_impl.dart`).
   Implement the contract. This is the only layer that touches
   storage/network/Firebase.

5. **Presentation — controller** (`presentation/<screen>/<screen>_controller.dart`).
   Use an async controller with `AsyncValue.guard`:
   ```dart
   import 'package:riverpod_annotation/riverpod_annotation.dart';

   part '<screen>_controller.g.dart';

   @riverpod
   class <Screen>Controller extends _$<Screen>Controller {
     @override
     FutureOr<void> build() {}

     Future<void> doSomething() async {
       state = const AsyncLoading();
       state = await AsyncValue.guard(() async {
         await ref.read(<feature>RepositoryProvider).fetchAll();
       });
     }
   }
   ```

6. **Presentation — screen** (`presentation/<screen>/<screen>_screen.dart`).
   A `ConsumerWidget`. Use `AppStrings.of(context)` for ALL user-facing text —
   never hardcode strings.

7. **Routing** — add the route to `lib/routing/app_router.dart`: add an
   `AppRouter` enum value and a `GoRoute` entry.

8. **Localization** — add any new string keys to the abstract `AppStrings`
   class and both `AppStringsFr` / `AppStringsEn` implementations.

9. **Generate code**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

10. **Verify**: run `flutter analyze` and `flutter test`; fix any issues.

## Reminders

- Never edit `.g.dart` / `.freezed.dart` files by hand.
- Keep UI free of direct Firebase/storage calls — always go through a repository.
- Mirror the new structure under `test/` and cover the controller.
