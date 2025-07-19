import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:nwcd_c/scanner.dart';

void main() {
  group('deviceVersionScan parsing', () {
    test('parses nmap output for versions and CVEs', () async {
      const sampleOutput = '''
Nmap scan report for 127.0.0.1
Host is up (0.00013s latency).
OS details: Ubuntu 20.04 LTS
Firmware Version: 1.2.3

PORT   STATE SERVICE VERSION
22/tcp open ssh OpenSSH 7.6
80/tcp open http Apache httpd 2.4.29
''';
      final result = await deviceVersionScan(
        '127.0.0.1',
        runProcess: (_, __) async => ProcessResult(0, 0, sampleOutput, ''),
      );

      expect(result.osVersion, 'Ubuntu 20.04 LTS');
      expect(result.firmwareVersion, '1.2.3');
      expect(result.softwareVersions, contains('OpenSSH 7.6'));
      expect(result.softwareVersions, contains('Apache httpd 2.4.29'));
      // Should find CVEs for Ubuntu, Apache and OpenSSH from cve_db.json
      expect(result.cveMatches, contains('CVE-2021-1234'));
      expect(result.cveMatches, contains('CVE-2022-0001'));
      expect(result.cveMatches, contains('CVE-2019-2034'));
    });

    test('returns unknown when process fails', () async {
      final result = await deviceVersionScan(
        '127.0.0.1',
        runProcess: (_, __) async => throw ProcessException('nmap', []),
      );
      expect(result.osVersion, 'Unknown');
      expect(result.firmwareVersion, 'Unknown');
      expect(result.softwareVersions, isEmpty);
      expect(result.cveMatches, isEmpty);
    });
  });
}
