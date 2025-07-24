import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:nwcd_c/risk_summary_page.dart';

void main() {
  testWidgets('Country summary table and chart render demo data',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RiskSummaryPage()));

    expect(find.text('通信先の国 一覧表示'), findsOneWidget);
    expect(find.byType(DataTable), findsOneWidget);
    expect(find.text('日本'), findsOneWidget);
    expect(find.text('134'), findsOneWidget);
    expect(find.byType(charts.PieChart), findsOneWidget);
  });
}
