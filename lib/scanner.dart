import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Basic device version information discovered during scans.
class DeviceVersionInfo {
  final String osVersion;
  final String firmwareVersion;
  final List<String> softwareVersions;
  final List<String> cveMatches;

  DeviceVersionInfo({
    required this.osVersion,
    required this.firmwareVersion,
    required this.softwareVersions,
    required this.cveMatches,
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
    return buffer.toString().trim();
  }
}

Future<String> scanDeviceVersion() async {
  await Future.delayed(const Duration(seconds: 1));
  return 'Device version: 1.0';
}

Future<String> checkOpenPorts() async {
  await Future.delayed(const Duration(seconds: 1));
  return 'Open ports: 80, 443';
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
      final match = RegExp(r'^\\d+/\\w+\\s+open\\s+[^\\s]+\\s+(.+)\\$').firstMatch(line.trim());
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
  } catch (_) {
    return DeviceVersionInfo(
      osVersion: 'Unknown',
      firmwareVersion: 'Unknown',
      softwareVersions: const [],
      cveMatches: const [],
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
