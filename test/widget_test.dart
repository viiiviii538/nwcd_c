import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nwcd_c/main.dart';

void main() {
  testWidgets('Scan navigates to results page', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('診断開始'));
    await tester.pump();
    // Wait for fake scan delay
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Scan Results'), findsOneWidget);
    expect(find.text('Port 21'), findsOneWidget);
  });
}
