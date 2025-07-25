import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Basic device version information discovered during scans.
class DeviceVersionInfo {
  final String osVersion;
  final String firmwareVersion;
  final List<String> softwareVersions;
  final List<String> cveMatches;
  final String? error;

  DeviceVersionInfo({
    required this.osVersion,
    required this.firmwareVersion,
    required this.softwareVersions,
    required this.cveMatches,
    this.error,
  });

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('OS: $osVersion');
    buffer.writeln('Firmware: $firmwareVersion');
    if (softwareVersions.isNotEmpty) {
      buffer.writeln('Software:');
      for (final s in softwareVersions) {
        buffer.writeln('  - $s');
      }
    }
    if (cveMatches.isNotEmpty) {
      buffer.writeln('Possible CVEs:');
      for (final cve in cveMatches) {
        buffer.writeln('  - $cve');
      }
    }
    if (error != null) {
      buffer.writeln('Error: $error');
    }
    return buffer.toString().trim();
  }
}

/// Result of an open port scan.
class PortScanResult {
  final String result;
  final String? error;

  PortScanResult(this.result, [this.error]);
}

Future<String> scanDeviceVersion() async {
  await Future.delayed(const Duration(seconds: 1));
  return 'Device version: 1.0';
}

/// Scan [ip] for common open TCP ports.
///
/// The function first tries to invoke `nmap` if it is available on the system
/// and parses the output for open ports. If `nmap` cannot be executed the
/// function falls back to attempting socket connections to a small set of
/// frequently used ports. The returned string lists the detected open ports or
/// `No open ports` when none are found or the scan fails.
Future<PortScanResult> checkOpenPorts({
  String ip = '127.0.0.1',
  Future<ProcessResult> Function(String, List<String>)? runProcess,
  Future<Socket> Function(String, int, {Duration? timeout})? socketConnect,
  List<int>? ports,
}) async {
  final openPorts = <int>[];
  bool success = false;
  String? error;

  try {
    final exec = runProcess ?? Process.run;
    final result = await exec('nmap', ['-p', '1-1024', ip]);
    if (result.exitCode == 0) {
      success = true;
      final lines = (result.stdout as String).split('\n');
      final regex = RegExp(r'^(\d+)/tcp\s+open');
      for (final line in lines) {
        final match = regex.firstMatch(line.trim());
        if (match != null) {
          openPorts.add(int.parse(match.group(1)!));
        }
      }
    }
  } on ProcessException {
    error = 'nmap command not found';
    // Ignore and fall back to socket based scanning
  }

  if (!success) {
    final portList = ports ??
        const [21, 22, 23, 25, 53, 80, 110, 143, 443, 445, 3389];
    try {
      for (final port in portList) {
        try {
          final connect = socketConnect ?? Socket.connect;
          final socket = await connect(ip, port,
              timeout: const Duration(milliseconds: 500));
          socket.destroy();
          openPorts.add(port);
          success = true;
        } catch (_) {
          // closed or unreachable
        }
      }
    } catch (_) {
      // Socket scanning failed
    }
  }

  if (!success) {
    return PortScanResult('Scan failed', error);
  }
  if (openPorts.isNotEmpty) {
    return PortScanResult('Open ports: ${openPorts.join(', ')}', error);
  }
  return PortScanResult('No open ports', error);
}

/// Scan a device at [ip] using `nmap` to gather version information.
///
/// The returned data includes detected operating system, firmware (if any),
/// discovered service versions and possible CVE matches from a local JSON
/// database. If `nmap` is unavailable, placeholder values are returned.
Future<DeviceVersionInfo> deviceVersionScan(
  String ip, {
  Future<ProcessResult> Function(String, List<String>)? runProcess,
}) async {
  try {
    final exec = runProcess ?? Process.run;
    final result = await exec('nmap', ['-O', '-sV', ip]);
    if (result.exitCode != 0) {
      throw ProcessException(
        'nmap',
        ['-O', '-sV', ip],
        result.stderr.toString(),
        result.exitCode,
      );
    }
    final output = result.stdout as String;

    final osMatch = RegExp(r'OS details: ([^\n]+)').firstMatch(output);
    final osVersion = osMatch?.group(1) ?? 'Unknown';

    // Firmware version is rarely exposed; look for a common pattern.
    final firmwareMatch = RegExp(r'Firmware Version: ([^\n]+)').firstMatch(output);
    final firmwareVersion = firmwareMatch?.group(1) ?? 'Unknown';

    final softwareVersions = <String>[];
    for (final line in LineSplitter.split(output)) {
      final match = RegExp(r'^\d+/\w+\s+open\s+[^\s]+\s+(.+)$').firstMatch(line.trim());
      if (match != null) {
        softwareVersions.add(match.group(1)!.trim());
      }
    }

    final cveMatches = await _lookupCves(osVersion, softwareVersions);

    return DeviceVersionInfo(
      osVersion: osVersion,
      firmwareVersion: firmwareVersion,
      softwareVersions: softwareVersions,
      cveMatches: cveMatches,
    );
  } on ProcessException {
    return DeviceVersionInfo(
      osVersion: 'Unknown',
      firmwareVersion: 'Unknown',
      softwareVersions: const [],
      cveMatches: const [],
      error: 'nmap command not found',
    );
  } catch (_) {
    return DeviceVersionInfo(
      osVersion: 'Unknown',
      firmwareVersion: 'Unknown',
      softwareVersions: const [],
      cveMatches: const [],
      error: 'Version scan failed',
    );
  }
}

Future<List<String>> _lookupCves(
  String osVersion,
  List<String> softwareVersions,
) async {
  final file = File('cve_db.json');
  if (!await file.exists()) return [];
  try {
    final jsonData = json.decode(await file.readAsString()) as Map<String, dynamic>;
    final matches = <String>[];

    final osMap = jsonData['os'] as Map<String, dynamic>? ?? {};
    for (final entry in osMap.entries) {
      if (osVersion.contains(entry.key)) {
        matches.addAll(List<String>.from(entry.value as List));
      }
    }

    final swMap = jsonData['software'] as Map<String, dynamic>? ?? {};
    for (final sw in softwareVersions) {
      for (final entry in swMap.entries) {
        if (sw.contains(entry.key)) {
          matches.addAll(List<String>.from(entry.value as List));
        }
      }
    }

    return matches.toSet().toList();
  } catch (_) {
    return [];
  }
}
