import 'package:mason/mason.dart';

void run(HookContext context) {
  final avecAuth = context.vars['avec_auth'] as bool;
  final avecFirebase = context.vars['avec_firebase'] as bool;

  if (avecAuth && !avecFirebase) {
    context.logger.warn(
      'Authentication requires Firebase. Enabling Firebase automatically.',
    );
    context.vars['avec_firebase'] = true;
  }

  context.logger.info('Generating ${context.vars['app_name']}...');
  context.logger.info('  Firebase : $avecFirebase');
  context.logger.info('  Auth     : $avecAuth');
}
