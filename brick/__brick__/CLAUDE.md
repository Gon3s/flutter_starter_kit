# {{app_name}} — Project Guide for Claude

> This project was generated from the **flutter_starter_kit** Mason brick.
> This file gives Claude (and any contributor) the conventions and commands to
> work effectively in this codebase. Keep it up to date as the project evolves.

## Project overview

{{app_description}}

- **State management:** Riverpod 3 with code generation (`@riverpod`)
- **Routing:** GoRouter with code generation + redirect guards
- **Models:** Freezed 3 + `json_serializable`
- **Architecture:** feature-first (`data` / `domain` / `presentation`)
{{#avec_firebase}}
- **Backend:** Firebase (Core, Analytics, Crashlytics, Messaging)
{{/avec_firebase}}
{{#avec_auth}}
- **Auth:** Firebase Auth Email/Password with secure session persistence
{{/avec_auth}}

## Golden rules

1. **Never hand-write generated files.** Files ending in `.g.dart` and
   `.freezed.dart` are produced by `build_runner`. Edit the source annotated
   file, then re-run the generator.
2. **Always run code generation after touching annotated files** (providers,
   Freezed models, routes):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   # or keep it running while you work:
   dart run build_runner watch --delete-conflicting-outputs
   ```
3. **No hardcoded user-facing strings.** Add them to `AppStrings` and the
   `AppStringsFr` / `AppStringsEn` implementations, then use
   `AppStrings.of(context).yourKey`.
4. **Keep the analyzer clean.** Run `flutter analyze` — this project uses
   `very_good_analysis` (strict lints). Fix warnings/errors before committing.
5. **Respect the feature-first layering.** UI never talks to Firebase/storage
   directly — it goes through a repository in `domain` implemented in `data`.

## Common commands

```bash
flutter pub get                                    # install deps
dart run build_runner build --delete-conflicting-outputs   # code gen
flutter run -t lib/main_dev.dart                   # run (development)
flutter run -t lib/main.dart                       # run (production)
flutter test                                       # run tests
flutter analyze                                    # lint
```

## Architecture & conventions

```
lib/
├── main.dart / main_dev.dart   # entry points (prod / dev flavors)
├── bootstrap.dart              # init + error zone + runApp
├── app.dart                    # MaterialApp.router, theme, localization
├── app_env.dart                # environment selector
├── common_widgets/             # shared widgets
├── constants/                  # sizes, spacing
├── localization/               # AppStrings (FR/EN)
├── routing/                    # GoRouter, app startup, 404
├── utils/                      # helpers
└── features/<feature>/
    ├── data/                   # repository implementations, DTOs
    ├── domain/                 # models + repository contracts (abstractions)
    └── presentation/<screen>/  # screen widget + Riverpod controller
```

### Adding a new feature

1. Create `lib/features/<feature>/{data,domain,presentation}/`.
2. Define the model with Freezed in `domain/` (remember: `abstract class`).
3. Define a repository **contract** (abstract class) in `domain/` and a
   `@riverpod` provider returning it.
4. Implement the repository in `data/`.
5. Build the screen + a `@riverpod` controller in `presentation/<screen>/`.
6. Register the route in `lib/routing/app_router.dart`.
7. Run `build_runner`.

### Riverpod 3.x notes (important)

- Functional providers take a plain `Ref` parameter — the old generated
  `*Ref` aliases (e.g. `MyProviderRef`) **no longer exist**.
- `isLoading` / `requireValue` are native on `AsyncValue` — don't redefine them.
- For async controllers, use `AsyncValue.guard` so the state transitions
  `AsyncLoading → AsyncData/AsyncError` cleanly:
  ```dart
  state = const AsyncLoading();
  state = await AsyncValue.guard(() async { /* work */ });
  ```

### Freezed 3.x notes

- Data classes that use `with _$X` **must be declared `abstract`**:
  ```dart
  @freezed
  abstract class MyModel with _$MyModel { ... }
  ```

{{#avec_auth}}
### Authentication

- The app depends on the `AuthRepository` **interface** (`domain/`), not on
  Firebase directly. `FirebaseAuthRepository` is the real impl;
  `FakeAuthRepository` is used in tests.
- Session is persisted via `flutter_secure_storage` and restored at app startup
  (`appStartupProvider`).
- The router redirects logged-out users to `/login` and logged-in users away
  from auth screens — see `goRouter` in `lib/routing/app_router.dart`.
{{/avec_auth}}

{{#avec_firebase}}
## Firebase setup

This repo does not ship real credentials. Generate them with the FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This produces `lib/firebase_options.dart` and the native credential files
(`android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`).
{{#avec_auth}}
Enable **Authentication → Sign-in method → Email/Password** in the Firebase
console.
{{/avec_auth}}

> ⚠️ Keep credential files out of version control on public repos.
{{/avec_firebase}}

## Testing conventions

- Tests use `mocktail`{{#avec_auth}} and `FakeAuthRepository` so they run
  without a live backend{{/avec_auth}}.
- Test controllers by listening to their `AsyncValue` state through a
  `ProviderContainer` with overridden providers.
- Mirror the `lib/` structure under `test/`.

## Before you commit

- [ ] `dart run build_runner build --delete-conflicting-outputs` (if you touched annotated files)
- [ ] `flutter analyze` is clean
- [ ] `flutter test` passes
- [ ] No hardcoded user-facing strings
