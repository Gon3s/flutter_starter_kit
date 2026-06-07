import 'dart:io';
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final avecAuth = context.vars['avec_auth'] as bool;
  final avecFirebase = context.vars['avec_firebase'] as bool;
  final appName = context.vars['app_name'] as String;
  final orgName = context.vars['org_name'] as String;

  // Remove auth feature and its auth-only dependencies if not needed.
  if (!avecAuth) {
    final authDir = Directory('lib/features/authentication');
    if (authDir.existsSync()) authDir.deleteSync(recursive: true);

    // These files are only used by the authentication feature.
    final authOnlyFiles = [
      'lib/db/secure_storage.dart',
      'lib/exceptions/app_exception.dart',
      'lib/exceptions/async_value_extensions.dart',
      'lib/utils/in_memory_state.dart',
      'test/features/authentication',
    ];
    for (final path in authOnlyFiles) {
      final dir = Directory(path);
      final file = File(path);
      if (dir.existsSync()) {
        dir.deleteSync(recursive: true);
      } else if (file.existsSync()) {
        file.deleteSync();
      }
    }

    // Remove now-empty lib/db directory.
    final dbDir = Directory('lib/db');
    if (dbDir.existsSync() && dbDir.listSync().isEmpty) {
      dbDir.deleteSync();
    }
    context.logger.info('Removed authentication feature.');
  }

  // Remove Firebase-specific files if not needed.
  if (!avecFirebase) {
    final filesToRemove = [
      'lib/utils/notification_service.dart',
      'lib/firebase_options.dart',
      'lib/firebase_options.example.dart',
    ];
    for (final path in filesToRemove) {
      final file = File(path);
      if (file.existsSync()) file.deleteSync();
    }
    context.logger.info('Removed Firebase files.');
  }

  // Add native platform folders (android/ios/...) if they are missing.
  // `flutter create .` is the documented way to add platform support to an
  // existing project; it preserves existing lib/ and pubspec.yaml.
  if (!Directory('android').existsSync() && !Directory('ios').existsSync()) {
    final createProgress =
        context.logger.progress('Scaffolding native platforms...');
    final create = await Process.run('flutter', [
      'create',
      '--org',
      orgName,
      '--project-name',
      appName,
      '.',
    ]);
    if (create.exitCode != 0) {
      createProgress.fail('flutter create failed:\n${create.stderr}');
      return;
    }

    // `flutter create` adds a default counter test that references a `MyApp`
    // class that does not exist in this template — remove it.
    final defaultTest = File('test/widget_test.dart');
    if (defaultTest.existsSync()) defaultTest.deleteSync();

    createProgress.complete('Native platforms scaffolded.');
  }

  // Run flutter pub get
  final progress = context.logger.progress('Running flutter pub get...');
  final pubGet = await Process.run('flutter', ['pub', 'get']);
  if (pubGet.exitCode != 0) {
    progress.fail('flutter pub get failed:\n${pubGet.stderr}');
    return;
  }
  progress.complete('flutter pub get done.');

  // Run build_runner
  final buildProgress = context.logger.progress('Running build_runner...');
  final buildRunner = await Process.run('dart', [
    'run',
    'build_runner',
    'build',
    '--delete-conflicting-outputs',
  ]);
  if (buildRunner.exitCode != 0) {
    buildProgress.fail(
      'build_runner failed:\n${buildRunner.stdout}\n${buildRunner.stderr}',
    );
    return;
  }
  buildProgress.complete('build_runner done.');

  context.logger.success('\nProject generated successfully!');

  context.logger.info(
    '\nThis project includes:\n'
    '  - CLAUDE.md       : project conventions & commands for Claude/contributors\n'
    "  - .claude/skills/ : a `new-feature` skill to scaffold features correctly",
  );

  if (avecFirebase) {
    context.logger.info(
      '\nNext steps:\n'
      '  1. Read CLAUDE.md for conventions and commands\n'
      '  2. Run `flutterfire configure` to generate lib/firebase_options.dart\n'
      '  3. Add Firebase secrets to GitHub Actions\n'
      '  4. Run your app with `flutter run -t lib/main_dev.dart`',
    );
  } else {
    context.logger.info(
      '\nNext steps:\n'
      '  1. Read CLAUDE.md for conventions and commands\n'
      '  2. Run your app with `flutter run -t lib/main_dev.dart`',
    );
  }
}
