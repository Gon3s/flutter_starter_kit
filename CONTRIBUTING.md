# Contributing to flutter_starter_kit

Thanks for your interest in improving this starter kit! This document explains
how to set up your environment and the conventions to follow.

## Prerequisites

- **Flutter** (stable channel) with **Dart ≥ 3.10** — some dependencies
  (e.g. `go_router 17`) require it. Run `flutter upgrade` if `pub get` fails on
  version solving.
- (Optional) **[Mason CLI][mason]** if you work on the bricks:
  `dart pub global activate mason_cli`.

## Getting started

```bash
git clone https://github.com/gon3s/flutter_starter_kit.git
cd flutter_starter_kit
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter test
```

## Project structure

This repo is **both a template and a Mason brick generator**:

- `lib/` — the starter app and **the source of truth**.
- `brick/` — the Mason brick that generates a full app (templated with Mustache).
- `bricks/flutter_auth_feature/` — a brick that adds the auth feature to an
  existing project.

See [`CLAUDE.md`](./CLAUDE.md) for the full conventions and framework gotchas.

## Conventions

- **Keep `lib/` and `brick/__brick__/lib/` in sync.** Any change to the app must
  be mirrored into the brick with correct templating:
  - wrap Firebase code in `{{#avec_firebase}}…{{/avec_firebase}}`
  - wrap auth code in `{{#avec_auth}}…{{/avec_auth}}`
  - replace the package name `gones_starter_kit` with `{{app_name}}`
- **Never edit generated files** (`*.g.dart`, `*.freezed.dart`). Edit the
  annotated source and re-run `build_runner`.
- **No hardcoded user-facing strings** — add them to `AppStrings` and both
  `AppStringsFr` / `AppStringsEn`.
- **Follow the feature-first architecture** (`data` / `domain` / `presentation`).
  UI talks to repositories, never to Firebase/storage directly.
- **Riverpod 3.x:** plain `Ref` params, `AsyncValue.guard` for async controllers.
- **Freezed 3.x:** data classes using `with _$X` must be `abstract`.

## Before opening a Pull Request

Please make sure all of the following pass:

```bash
dart run build_runner build --delete-conflicting-outputs   # if annotated files changed
flutter analyze        # must be clean (very_good_analysis)
flutter test           # all tests green
```

If you changed the brick, verify it still generates a valid project:

```bash
mason add flutter_starter_kit --path ./brick
cd /tmp && mkdir demo && cd demo
mason make flutter_starter_kit --on-conflict overwrite
flutter analyze && flutter test
```

## Commit messages

Use [Conventional Commits](https://www.conventionalcommits.org/) where possible
(`feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`).

## License

By contributing, you agree that your contributions will be licensed under the
[MIT License](./LICENSE.md).

[mason]: https://pub.dev/packages/mason_cli
