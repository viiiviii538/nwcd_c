import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nwcd_c/main.dart';
import 'package:nwcd_c/network_diagram.dart';
import 'package:nwcd_c/network_scan_isolate.dart';
import 'package:nwcd_c/network_scanner.dart';
import 'package:nwcd_c/topology_scanner.dart';

void main() {
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

  test('networkScanIsolate sends serialized map data', () async {
    final port = ReceivePort();
    await Isolate.spawn(networkScanIsolate, [port.sendPort, fakeScan]);
    final message = await port.first;
    port.close();
    expect(message, isA<List<Map<String, String>>>());
  });

  testWidgets('Network diagram displays using isolate results',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(
      networkScanFn: fakeScan,
      topologyScanFn: () async => <TopologyLink>[],
    ));

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
