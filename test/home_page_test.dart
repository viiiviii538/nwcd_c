import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nwcd_c/main.dart';

void main() {
  testWidgets('Full scan shows results', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Navigate to full scan tab
    await tester.tap(find.widgetWithText(Tab, 'フルスキャン'));
    await tester.pumpAndSettle();

    // Start full scan and expect progress indicator
    await tester.tap(find.text('フルスキャン開始'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for scan to finish and results to appear in the same tab
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    expect(find.text('デバイス情報'), findsOneWidget);
    expect(find.text('ポート開放状況'), findsOneWidget);
    expect(find.text('脆弱性情報'), findsOneWidget);

    // Button should be enabled again after results are shown
    expect(find.text('フルスキャン開始'), findsOneWidget);
  });
}
