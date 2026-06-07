{{#avec_auth}}
import 'package:{{app_name}}/features/authentication/data/fake_auth_repository.dart';
import 'package:{{app_name}}/features/authentication/data/session_storage.dart';
{{/avec_auth}}
{{#avec_firebase}}
import 'package:{{app_name}}/utils/notification_service.dart';
{{/avec_firebase}}
import 'package:mocktail/mocktail.dart';

// A generic Listener class, used to track when a provider notifies its listeners.
class Listener<T> extends Mock {
  void call(T? previous, T next);
}
{{#avec_auth}}

class MockAuthRepository extends Mock implements FakeAuthRepository {}

class MockSessionStorage extends Mock implements SessionStorage {}
{{/avec_auth}}
{{#avec_firebase}}

class MockNotificationService extends Mock implements NotificationService {}
{{/avec_firebase}}
