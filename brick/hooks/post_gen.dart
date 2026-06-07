import 'dart:io';
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final avecAuth = context.vars['avec_auth'] as bool;
  final avecFirebase = context.vars['avec_firebase'] as bool;

  // Remove auth feature directory if not needed
  if (!avecAuth) {
    final authDir = Directory('lib/features/authentication');
    if (authDir.existsSync()) {
      authDir.deleteSync(recursive: true);
      context.logger.info('Removed authentication feature.');
    }
  }

  // Remove Firebase-specific files if not needed
  if (!avecFirebase) {
    final filesToRemove = [
      'lib/utils/notification_service.dart',
      'lib/firebase_options.example.dart',
    ];
    for (final path in filesToRemove) {
      final file = File(path);
      if (file.existsSync()) file.deleteSync();
    }
    context.logger.info('Removed Firebase files.');
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
    buildProgress.fail('build_runner failed:\n${buildRunner.stderr}');
    return;
  }
  buildProgress.complete('build_runner done.');

  context.logger.success('\nProject generated successfully!');

  if (avecFirebase) {
    context.logger.info(
      '\nNext steps:\n'
      '  1. Run `flutterfire configure` to generate lib/firebase_options.dart\n'
      '  2. Add Firebase secrets to GitHub Actions\n'
      '  3. Run your app with `flutter run`',
    );
  } else {
    context.logger.info('\nNext steps:\n  1. Run your app with `flutter run`');
  }
}
