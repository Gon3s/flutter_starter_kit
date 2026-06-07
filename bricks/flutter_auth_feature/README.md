# flutter_auth_feature

Adds a complete Firebase Auth (Email/Password) feature to an **existing**
Flutter + Riverpod project.

## Prerequisites

This brick generates the authentication feature and its auth-only dependencies
(`lib/db/secure_storage.dart`, `lib/exceptions/`). It assumes the host project
already provides the following (all present in projects generated from the
`flutter_starter_kit` brick):

**Packages** in `pubspec.yaml`:

```yaml
dependencies:
  firebase_core: ^4.10.0
  firebase_auth: ^6.5.2
  firebase_messaging: ^16.3.0      # used by notification_service
  flutter_riverpod: ^3.3.1
  flutter_secure_storage: ^10.3.1
  freezed_annotation: ^3.1.0
  go_router: ^17.3.0
  json_annotation: ^4.12.0
  riverpod_annotation: ^4.0.2
dev_dependencies:
  build_runner: ^2.15.0
  freezed: ^3.2.5
  json_serializable: ^6.14.0
  mocktail: ^1.0.5
```

**Host files** the generated screens import (create them if missing):

- `lib/localization/app_strings.dart` — `AppStrings.of(context)` with the keys
  used by the auth screens (email, password, signIn, signUp, account…)
- `lib/common_widgets/primary_button.dart` — a `PrimaryButton` widget
- `lib/constants/app_sizes.dart` — `Sizes` / `gapHxx` spacing helpers
- `lib/utils/string_validator.dart`, `lib/utils/delay.dart`,
  `lib/utils/in_memory_state.dart`
- `lib/utils/notification_service.dart` — registered device on session restore
- `lib/routing/app_router.dart`, `lib/routing/app_startup.dart`

> 💡 The easiest way to satisfy all prerequisites is to start from the full
> `flutter_starter_kit` brick. Use this feature brick mainly to re-add or update
> the auth feature in such a project.

## Usage

```bash
dart pub global activate mason_cli
mason add flutter_auth_feature --path ./bricks/flutter_auth_feature
mason make flutter_auth_feature
```

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `app_name` | string | `my_app` | Your existing package name (snake_case) |
| `output_dir` | string | `lib/features/authentication` | Output directory |

## What's generated

```
lib/
├── db/secure_storage.dart                # SecureStorage provider
├── exceptions/
│   ├── app_exception.dart                # typed auth exceptions
│   └── async_value_extensions.dart       # showSnackBarOnError
└── features/authentication/
    ├── data/
    │   ├── auth_session.dart             # Freezed session model
    │   ├── fake_auth_repository.dart     # for tests
    │   ├── firebase_auth_repository.dart # real implementation
    │   └── session_storage.dart          # SecureStorage wrapper
    ├── domain/
    │   ├── app_user.dart                 # Freezed user model
    │   ├── auth_repository.dart          # contract + provider
    │   └── fake_app_user.dart
    └── presentation/
        ├── account/
        │   ├── account_controller.dart
        │   ├── account_screen.dart
        │   └── change_password_controller.dart
        ├── sign_in/{sign_in_controller,sign_in_screen}.dart
        ├── sign_up/{sign_up_controller,sign_up_screen}.dart
        └── auth_validators.dart
```

## Post-generation

1. Switch the router provider to use `FirebaseAuthRepository` (already wired in
   `auth_repository.dart`).
2. Add the `login`, `signUp`, and `account` routes + the auth redirect logic to
   your `app_router.dart` (see the `flutter_starter_kit` brick for reference).
3. Make `appStartup` restore the session via `sessionStorageProvider`.
4. Enable **Email/Password** sign-in in the Firebase console.
5. Run:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   flutter analyze && flutter test
   ```
