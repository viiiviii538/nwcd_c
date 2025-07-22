import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:nwcd_c/scanner.dart';

void main() {
  test('parses nmap output for open ports', () async {
    const sample = '22/tcp open ssh\n80/tcp open http';
    final result = await checkOpenPorts(
      '127.0.0.1',
      runProcess: (_, __) async => ProcessResult(0, 0, sample, ''),
    );
    expect(result.result, 'Open ports: 22, 80');
    expect(result.error, isNull);
  });

  test('falls back to socket scan on ProcessException', () async {
    final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    final result = await checkOpenPorts(
      '127.0.0.1',
      runProcess: (_, __) async => throw ProcessException('nmap', []),
      ports: [server.port],
    );
    await server.close();
    expect(result.result, 'Open ports: ${server.port}');
    expect(result.error, 'nmap command not found');
  });
  test('returns failure message when scan cannot be performed', () async {
    final result = await checkOpenPorts(
      '127.0.0.1',
      runProcess: (_, __) async => throw ProcessException('nmap', []),
      socketConnect: (_, __, {timeout}) async => throw SocketException('fail'),
    );
    expect(result.result, 'Scan failed');
    expect(result.error, 'nmap command not found');
  });

}
