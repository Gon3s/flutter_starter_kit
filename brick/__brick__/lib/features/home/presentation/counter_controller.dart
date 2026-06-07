import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'counter_controller.g.dart';

@riverpod

/// Controller for the counter feature.
class CounterController extends _$CounterController {
  @override
  int build() => 0;

  /// Increment the counter.
  void increment() => state++;
}
