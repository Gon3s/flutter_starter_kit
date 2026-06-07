# flutter_auth_feature

Adds Firebase Auth (Email/Password) to an existing Flutter + Riverpod project.

## Prerequisites

- Flutter project with Riverpod, GoRouter, Freezed
- Firebase initialized (`firebase_core`, `firebase_auth` in `pubspec.yaml`)

## Usage

```bash
mason make flutter_auth_feature
```

## What's generated

```
lib/features/authentication/
├── data/
│   ├── auth_session.dart        # Freezed session model
│   ├── firebase_auth_repository.dart
│   └── session_storage.dart     # SecureStorage wrapper
├── domain/
│   ├── app_user.dart            # Freezed user model
│   ├── auth_repository.dart     # Abstract + provider
│   └── fake_auth_repository.dart  # For tests
└── presentation/
    ├── account/
    │   ├── account_controller.dart
    │   ├── account_screen.dart
    │   └── change_password_controller.dart
    ├── sign_in/
    │   ├── sign_in_controller.dart
    │   └── sign_in_screen.dart
    ├── sign_up/
    │   ├── sign_up_controller.dart
    │   └── sign_up_screen.dart
    └── auth_validators.dart
```

## Post-generation

1. Add routes to your `app_router.dart`
2. Add redirect logic to GoRouter
3. Run `dart run build_runner build --delete-conflicting-outputs`
