import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nwcd_c/main.dart';
import 'package:nwcd_c/network_scanner.dart';
import 'package:nwcd_c/network_diagram.dart';

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
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.byType(DataTable), findsOneWidget);
    expect(find.text('OSアップデート未適用'), findsOneWidget);
    expect(find.text('CVE脆弱性検出あり'), findsOneWidget);
    expect(find.text('開放ポート'), findsOneWidget);
    // Row information should include scan results
    expect(find.text('127.0.0.1'), findsOneWidget);
    expect(find.text('Yes'), findsOneWidget);
    expect(find.text('No'), findsOneWidget);
    expect(find.text('フルスキャン開始'), findsOneWidget);
  });

  testWidgets('Network scan displays diagram', (WidgetTester tester) async {
    Future<List<NetworkDevice>> fakeScan() async {
      return [
        NetworkDevice(
          ip: '192.168.1.2',
          mac: '00:11:22:33:44:55',
          vendor: 'TestVendor',
          name: 'Device1',
        ),
      ];
    }

    await tester.pumpWidget(MyApp(networkScanFn: fakeScan));

    await tester.tap(find.widgetWithText(Tab, 'ネットワーク図'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('ネットワークスキャン開始'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.byType(NetworkDiagram), findsOneWidget);
  });
}
