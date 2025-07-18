import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:nwcd_c/port_scanner.dart';

void main() {
  group('PortScanner', () {
    const scanner = PortScanner();

    test('isPortOpen returns true for open port and false when closed', () async {
      final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      final port = server.port;
      expect(await scanner.isPortOpen('localhost', port), isTrue);
      await server.close();
      // After closing, the port should no longer be open
      expect(await scanner.isPortOpen('localhost', port), isFalse);
    });

    test('scanPorts scans multiple ports', () async {
      final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      final openPort = server.port;
      final closedPort = openPort + 1;
      final results = await scanner.scanPorts('localhost', [openPort, closedPort]);
      expect(results[openPort], isTrue);
      expect(results[closedPort], isFalse);
      await server.close();
    });
  });
}
