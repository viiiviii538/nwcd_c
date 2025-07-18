import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nwcd_c/main.dart';

void main() {
  testWidgets('Real-time and full scan flows', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Start real-time scanning
    await tester.tap(find.text('リアルタイム開始'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Tap the full scan button
    await tester.tap(find.text('フルスキャン'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('フルスキャン開始'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for navigation to result page
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Verify result page shows a completion button
    expect(find.text('完了'), findsOneWidget);
  });
}
