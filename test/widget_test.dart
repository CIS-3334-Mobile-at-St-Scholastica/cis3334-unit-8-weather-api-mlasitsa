// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_weatherapi_f25/main.dart';

void main() {
  testWidgets('App builds and shows title', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify our app bar/title text is present.
    expect(find.text('CIS 3334 Weather App'), findsOneWidget);

    // The FutureBuilder may still be loading; ensure it builds without crashing.
    // Optionally pump a bit to advance a frame.
    await tester.pump(const Duration(milliseconds: 100));

    // We are not asserting network results, just that the widget tree builds.
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
