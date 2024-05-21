import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gones_starter_kit/features/home/presentation/home_screen.dart';

void main() {
  // Confirm that the initial counter value is displayed correctly upon loading the HomeScreen
  testWidgets('Initial counter value is displayed correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HomeScreen(title: 'Test Title'),
        ),
      ),
    );

    expect(find.text('You have pushed the button this many times:'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
  });

  // Check if the FloatingActionButton increments the counter on press
  testWidgets('Verify if FloatingActionButton increments counter on press', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HomeScreen(title: 'Test Title'),
        ),
      ),
    );

    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
  });
}
