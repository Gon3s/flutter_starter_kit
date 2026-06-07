@Timeout(Duration(milliseconds: 500))
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{app_name}}/features/home/presentation/home_screen.dart';

void main() {
  testWidgets('Initial counter value is displayed correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    // English fallback since no localization ancestor
    expect(find.text('You have pushed the button this many times:'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('Verify if FloatingActionButton increments counter on press', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
  });
}
