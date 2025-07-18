import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nwcd_c/main.dart';

void main() {
  testWidgets('Real-time and full scan flows', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Tap the real-time scan button
    await tester.tap(find.text('リアルタイム'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the scan to finish
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.text('リアルタイム'), findsOneWidget);
    expect(find.text('フルスキャン'), findsOneWidget);

    // Tap the full scan button
    await tester.tap(find.text('フルスキャン'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for navigation to result page
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Verify result page shows a completion button
    expect(find.text('完了'), findsOneWidget);
  });
}
