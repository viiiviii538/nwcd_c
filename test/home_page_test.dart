import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nwcd_c/main.dart';

void main() {
  testWidgets('Full scan shows results in tab', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Navigate to full scan tab
    await tester.tap(find.widgetWithText(Tab, 'フルスキャン'));
    await tester.pumpAndSettle();

    // Start full scan and expect progress indicator
    await tester.tap(find.text('フルスキャン開始'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for scan to finish and results to display
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('OSアップデート未適用'), findsOneWidget);
    expect(find.text('RDPポート開放 (3389)'), findsOneWidget);
    expect(find.text('CVE脆弱性検出あり'), findsOneWidget);
    expect(find.text('フルスキャン開始'), findsOneWidget);
  });
}
