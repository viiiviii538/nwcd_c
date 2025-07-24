import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nwcd_c/main.dart';

void main() {
  testWidgets('Full scan shows table results', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Navigate to full scan tab
    await tester.tap(find.widgetWithText(Tab, 'フルスキャン'));
    await tester.pumpAndSettle();

    // Start full scan and expect progress indicator
    await tester.tap(find.text('フルスキャン開始'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for scan to finish and results to display
    await tester.pump(const Duration(seconds: 12));
    await tester.pumpAndSettle();

    expect(find.byType(DataTable), findsOneWidget);
    expect(find.text('OSアップデート未適用'), findsOneWidget);
    expect(find.text('CVE脆弱性検出あり'), findsOneWidget);
    expect(find.text('開放ポート'), findsOneWidget);
    // Row information should be populated
    expect(find.textContaining('.'), findsWidgets);
    expect(find.text('フルスキャン開始'), findsOneWidget);
  });

  testWidgets('Risk summary tab displays text', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.widgetWithText(Tab, 'リスクまとめ'));
    await tester.pumpAndSettle();

    expect(find.text('リスク要約'), findsOneWidget);
    expect(find.textContaining('ネットワークスキャン'), findsOneWidget);
  });
}
