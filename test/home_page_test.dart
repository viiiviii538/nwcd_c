import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nwcd_c/main.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;

void main() {
  testWidgets('Full scan shows table results', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Navigate to full scan tab
    await tester.tap(find.widgetWithText(Tab, 'フルスキャン診断'));
    await tester.pumpAndSettle();

    // Start full scan and expect progress indicator
    await tester.tap(find.text('フルスキャン開始'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for scan to finish and results to display
    await tester.pump(const Duration(seconds: 12));
    await tester.pumpAndSettle();

    expect(find.byType(DataTable), findsWidgets);
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
    expect(find.textContaining('デフォルト/弱いパスワード'), findsOneWidget);
    expect(find.textContaining('安全でないプロトコル'), findsOneWidget);
    expect(find.textContaining('管理インターフェースの外部公開'), findsOneWidget);
    expect(find.textContaining('ネットワーク分割や監視体制の不足'), findsOneWidget);
    expect(find.byType(DataTable), findsWidgets);
    expect(find.text('日本'), findsOneWidget);
    expect(find.text('134'), findsOneWidget);
    expect(find.byType(charts.PieChart), findsOneWidget);
    expect(find.text('危険な通信デモ'), findsOneWidget);
    expect(find.text('宛先ホスト名/IP'), findsOneWidget);
    expect(find.text('通信種別'), findsOneWidget);
    expect(find.text('暗号化状態'), findsOneWidget);
    expect(find.text('test.example.com'), findsOneWidget);
    expect(find.text('HTTP'), findsOneWidget);
    expect(find.text('TELNET'), findsOneWidget);
    expect(find.text('通信量が異常な機器'), findsOneWidget);
    expect(find.text('IPアドレス'), findsOneWidget);
    expect(find.text('デバイス名'), findsOneWidget);
    expect(find.text('通信量（MB/分）'), findsOneWidget);
    expect(find.text('192.168.0.12'), findsOneWidget);
    expect(find.text('PC-A'), findsOneWidget);
    expect(find.text('未知の家庭用ルーター'), findsOneWidget);
  });
}
