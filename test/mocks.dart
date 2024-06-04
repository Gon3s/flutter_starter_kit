import 'package:gones_starter_kit/features/authentication/data/fake_auth_repository.dart';
import 'package:mocktail/mocktail.dart';

// a generic Listener class, used to keep track of when a provider notifies its listeners
class Listener<T> extends Mock {
  void call(T? previous, T next);
}

class MockAuthRepository extends Mock implements FakeAuthRepository {}
