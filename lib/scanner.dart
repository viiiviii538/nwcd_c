import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'device_info.dart';

Future<List<String>> _enumerateLocalIps() async {
  try {
    final result = await Process.run('arp', ['-a']).timeout(const Duration(seconds: 5));
    if (result.exitCode == 0) {
      final regex = RegExp(r'((?:\\d{1,3}\\.){3}\\d{1,3})');
      return regex
          .allMatches(result.stdout.toString())
          .map((m) => m.group(1)!)
          .toSet()
          .toList();
    }
  } catch (_) {}
  return [];
}

Future<List<DeviceInfo>> deviceVersionScan() async {
  final ips = await _enumerateLocalIps();
  final devices = <DeviceInfo>[];
  for (final ip in ips) {
    final info = DeviceInfo(ip: ip);
    try {
      final nmap = await Process.run('nmap', ['-O', ip]).timeout(const Duration(seconds: 10));
      if (nmap.exitCode == 0) {
        final output = nmap.stdout.toString();
        final osMatch = RegExp(r'OS details: (.*)').firstMatch(output) ??
            RegExp(r'Running: (.*)').firstMatch(output);
        if (osMatch != null) {
          info.osVersion = osMatch.group(1)!.trim();
        }
        final portMatches = RegExp(r'^(\\d+)/tcp\\s+open', multiLine: true)
            .allMatches(output)
            .map((m) => int.tryParse(m.group(1)!) ?? 0)
            .where((p) => p > 0)
            .toList();
        if (portMatches.isNotEmpty) info.openPorts = portMatches;
      }
    } catch (_) {}

    if (info.osVersion != null) {
      try {
        final uri = Uri.parse('https://cve.circl.lu/api/search/${Uri.encodeComponent(info.osVersion!)}');
        final request = await HttpClient().getUrl(uri).timeout(const Duration(seconds: 5));
        final response = await request.close().timeout(const Duration(seconds: 5));
        if (response.statusCode == 200) {
          final body = await response.transform(utf8.decoder).join();
          final data = json.decode(body);
          if (data is List) {
            info.vulnerabilities =
                data.map<String>((e) => e['id'].toString()).take(5).toList();
          }
        }
      } catch (_) {}
    }

    devices.add(info);
  }
  return devices;
}

/// Simple representation of a scanned device.
class DeviceInfo {
  DeviceInfo({
    required this.name,
    required this.osUpdatePending,
    required this.rdpOpen,
    required this.hasCve,
  });

  final String name;
  final bool osUpdatePending;
  final bool rdpOpen;
  final bool hasCve;
}

/// Information returned from a device scan.
class DeviceInfo {
  final String name;
  final String version;

  DeviceInfo({required this.name, required this.version});
}

/// Signature for a function that performs a device version scan.
typedef DeviceVersionScanner = Future<List<DeviceInfo>> Function();

/// The actual scanner used by [deviceVersionScan].
DeviceVersionScanner deviceVersionScan = _defaultDeviceVersionScan;

Future<List<DeviceInfo>> _defaultDeviceVersionScan() async {
  await Future.delayed(const Duration(seconds: 1));
  return [DeviceInfo(name: 'Device A', version: '1.0')];
Future<String> scanDeviceVersion() async {
  try {
    final devices = await deviceVersionScan();
    if (devices.isEmpty) return 'No devices found';
    return devices.map((d) => d.toString()).join('\n\n');
  } catch (e) {
    return 'Scan failed: $e';
  }
}

Future<String> checkOpenPorts() async {
  await Future.delayed(const Duration(seconds: 1));
  return 'Open ports: 80, 443';
}

/// Mock scan that returns a list of [DeviceInfo] objects.
Future<List<DeviceInfo>> deviceVersionScan() async {
  await Future.delayed(const Duration(seconds: 1));
  // The returned data is static for demo purposes.
  return [
    DeviceInfo(
      name: 'Device A',
      osUpdatePending: true,
      rdpOpen: false,
      hasCve: true,
    ),
    DeviceInfo(
      name: 'Device B',
      osUpdatePending: false,
      rdpOpen: true,
      hasCve: false,
    ),
    DeviceInfo(
      name: 'Device C',
      osUpdatePending: true,
      rdpOpen: true,
      hasCve: true,
    ),
  ];
}
