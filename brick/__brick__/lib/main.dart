import 'package:{{app_name}}/app_env.dart';
import 'package:{{app_name}}/bootstrap.dart';

void main() async {
  await bootstrap(AppEnvironment.production);
}
