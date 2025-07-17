import 'dart:convert';
import 'dart:io';

import 'models/scan_result.dart';

class ScanService {
  static const String _scriptPath = 'scripts/network_scanner/scanner.py';

  Future<ScanResult> runScan() async {
    try {
      final result = await Process.run(
        'python3',
        [_scriptPath, '127.0.0.1', '--json'],
      );
      if (result.exitCode != 0) {
        throw Exception(result.stderr.toString());
      }
      return ScanResult.fromJsonString(result.stdout.toString());
    } on ProcessException {
      throw Exception('Scanner script not found');
    } on FormatException {
      throw Exception('Invalid JSON returned from scanner');
    }
  }
}
