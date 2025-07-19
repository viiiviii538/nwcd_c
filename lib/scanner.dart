import 'dart:async';
import 'dart:io';

/// Returns basic operating system information for the current device.
///
/// The function uses [Platform.operatingSystem] and
/// [Platform.operatingSystemVersion] to gather real data rather than the
/// hard coded values previously returned.
Future<String> scanDeviceVersion() async {
  await Future.delayed(const Duration(seconds: 1));
  final os = Platform.operatingSystem;
  final version = Platform.operatingSystemVersion;
  return 'Device OS: $os\nVersion: $version';
}

/// Checks a handful of common ports on localhost and lists the ones that are
/// accepting connections.
///
/// Currently ports 3389 (RDP), 80, 443 and 22 are tested. The scan runs with a
/// short timeout so the function returns quickly when ports are closed.
Future<String> checkOpenPorts() async {
  const ports = [3389, 80, 443, 22];
  final openPorts = <int>[];
  for (final port in ports) {
    try {
      final socket =
          await Socket.connect('127.0.0.1', port, timeout: const Duration(milliseconds: 200));
      await socket.close();
      openPorts.add(port);
    } catch (_) {
      // Connection failed - port is likely closed.
    }
  }
  await Future.delayed(const Duration(milliseconds: 500));
  return openPorts.isEmpty
      ? 'No open ports detected'
      : 'Open ports: ${openPorts.join(', ')}';
}

/// Performs a very small local CVE lookup based on the OS information.
///
/// Without network access a tiny built in database is used. If no matches are
/// found the function returns a message saying so.
Future<String> scanLocalCveVulnerabilities() async {
  await Future.delayed(const Duration(milliseconds: 500));
  final version = Platform.operatingSystemVersion.toLowerCase();
  final vulnerabilities = <String>[];

  if (version.contains('ubuntu 20.04')) {
    vulnerabilities.add('CVE-2021-3156');
  } else if (version.contains('windows')) {
    vulnerabilities.add('CVE-2020-0601');
  }

  return vulnerabilities.isEmpty
      ? 'No known CVEs found'
      : 'Potential CVEs: ${vulnerabilities.join(', ')}';
}
