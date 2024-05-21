import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'counter_controller.g.dart';

/// The controller for the counter feature.
@riverpod
class CounterController extends _$CounterController {
  @override
  int build() => 0;

  /// Increments the counter state.
  void increment() {
    state++;
  }
}
