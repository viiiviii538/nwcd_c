import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nwcd_c/main.dart';
import 'package:nwcd_c/port_scanner.dart';

void main() {
  testWidgets('HomePage shows scan button', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(scanner: const PortScanner()));

    expect(find.text('診断開始'), findsOneWidget);

    await tester.tap(find.text('診断開始'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Scan results appear after tapping button',
      (WidgetTester tester) async {
    class FakePortScanner extends PortScanner {
      const FakePortScanner();

      @override
      Future<Map<int, bool>> scanPorts(String host, List<int> ports,
              {Duration timeout = const Duration(seconds: 1)}) async =>
          {for (final p in ports) p: true};

      @override
      Future<bool> isPortOpen(String host, int port,
              {Duration timeout = const Duration(seconds: 1)}) async =>
          true;
    }

    await tester.pumpWidget(MyApp(scanner: const FakePortScanner()));
    await tester.tap(find.text('診断開始'));
    await tester.pump();
    expect(find.text('Port 80: open'), findsOneWidget);
  });
}
