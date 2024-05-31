import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gones_starter_kit/features/home/presentation/counter_controller.dart';
import 'package:mocktail/mocktail.dart';

// a generic Listener class, used to keep track of when a provider notifies its listeners
class Listener<T> extends Mock {
  void call(T? previous, T next);
}

void main() {
  group('CounterController', () {
    test('initial state is 0 and notify when value changes', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final listener = Listener<int>();

      container.listen<int>(
        counterControllerProvider,
        listener.call,
        fireImmediately: true,
      );

      verify(() => listener(null, 0)).called(1);
      verifyNoMoreInteractions(listener);

      // We increment the value
      container.read(counterControllerProvider.notifier).state++;

      // The listener was called again, but with 1 this time
      verify(() => listener(0, 1)).called(1);
      verifyNoMoreInteractions(listener);
    });

    test('increment method increments the state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final listener = Listener<int>();

      container.listen<int>(
        counterControllerProvider,
        listener.call,
        fireImmediately: true,
      );

      verify(() => listener(null, 0)).called(1);
      verifyNoMoreInteractions(listener);

      // We increment the value
      container.read(counterControllerProvider.notifier).increment();

      // The listener was called again, but with 1 this time
      verify(() => listener(0, 1)).called(1);
      verifyNoMoreInteractions(listener);
    });
  });
}
