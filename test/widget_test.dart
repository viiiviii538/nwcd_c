import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nwcd_c/main.dart';

void main() {
  testWidgets('HomePage scan navigates to ScanResultPage with expected items', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MyApp());

    // Verify scan button is present
    expect(find.text('診断開始'), findsOneWidget);

    // Tap the scan button
    await tester.tap(find.text('診断開始'));
    await tester.pump(); // start scanning

    // Wait for the simulated scan duration
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Verify navigation to the result page
    expect(find.text('診断結果ページ'), findsOneWidget);
    expect(find.text('危険ポートの個数（danger_ports）'), findsOneWidget);
  });
}
