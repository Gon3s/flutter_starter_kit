# flutter_starter_kit — Repository Guide for Claude

This repository is **both a Flutter starter template and a Mason brick
generator**. When you change the template, you usually need to mirror the change
into the brick — keep the two in sync.

## Repository layout

```
.
├── lib/                         # The actual starter app (source of truth)
├── test/                        # Tests for the app
├── .github/workflows/           # CI (analyze + test, optional Firebase secrets)
├── brick/                       # Mason brick that generates a full app
│   ├── brick.yaml               # variables: app_name, org_name, app_description,
│   │                            #            avec_firebase, avec_auth
│   ├── __brick__/               # templated project (Mustache: {{var}}, {{#bool}})
│   │   ├── CLAUDE.md            # CLAUDE.md shipped INTO generated projects
│   │   └── .claude/skills/      # skills shipped INTO generated projects
│   └── hooks/                   # pre_gen / post_gen Dart hooks
└── bricks/flutter_auth_feature/ # Mason brick: auth feature for existing projects
```

## Golden rules

1. **`lib/` is the source of truth.** When you add/modify a file in `lib/`,
   reflect it in `brick/__brick__/lib/` with the right Mustache templating
   (wrap Firebase code in `{{#avec_firebase}}…{{/avec_firebase}}` and auth code
   in `{{#avec_auth}}…{{/avec_auth}}`, replace the package name
   `gones_starter_kit` with `{{app_name}}`).
2. **Never hand-write generated files** (`*.g.dart`, `*.freezed.dart`). Run:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
3. **Keep the analyzer clean** — `flutter analyze` uses `very_good_analysis`.
   The `brick/**` and `bricks/**` dirs are excluded (they contain Mustache, not
   valid Dart).
4. **No hardcoded user-facing strings** — add them to `AppStrings` + the
   `AppStringsFr`/`AppStringsEn` implementations.

## Common commands

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -t lib/main_dev.dart      # dev flavor
flutter run -t lib/main.dart          # prod flavor
flutter test
flutter analyze
```

## Framework gotchas

- **Riverpod 3.x:** functional providers take a plain `Ref` (the generated
  `*Ref` aliases were removed). `isLoading`/`requireValue` are native on
  `AsyncValue`. Use `AsyncValue.guard` in async controllers.
- **Freezed 3.x:** data classes using `with _$X` must be declared `abstract`.
- **go_router 17:** requires Dart ≥ 3.10 — use a recent stable Flutter
  (`flutter upgrade`) if `pub get` reports a version conflict.

## Testing the brick locally

```bash
mason add flutter_starter_kit --path ./brick
cd /tmp && mkdir demo && cd demo
mason make flutter_starter_kit --on-conflict overwrite
flutter analyze && flutter test
```

## Before you commit

- [ ] `lib/` changes mirrored into `brick/__brick__/` (with templating)
- [ ] `flutter analyze` clean
- [ ] `flutter test` passes
- [ ] Generated code regenerated if annotated files changed
