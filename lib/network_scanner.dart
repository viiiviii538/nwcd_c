import 'dart:io';

class NetworkDevice {
  final String ip;
  final String mac;
  final String vendor;
  final String name;

  NetworkDevice({
    required this.ip,
    required this.mac,
    required this.vendor,
    required this.name,
  });
}

Future<List<NetworkDevice>> scanNetwork() async {
  try {
    ProcessResult result;
    if (Platform.isWindows) {
      result = await Process.run('arp', ['-a']);
    } else {
      result = await Process.run('arp', ['-a']);
      if (result.exitCode != 0 || (result.stdout as String).toString().trim().isEmpty) {
        result = await Process.run('ip', ['neigh']);
      }
    }

    if (result.exitCode != 0) return [];

    final output = result.stdout as String;
    return _parseScanOutput(output);
  } catch (_) {
    return [];
  }
}

List<NetworkDevice> _parseScanOutput(String output) {
  final devices = <NetworkDevice>[];
  for (final line in output.split('\n')) {
    final device = _parseDeviceLine(line.trim());
    if (device != null) {
      devices.add(device);
    }
  }
  return devices;
}

NetworkDevice? _parseDeviceLine(String line) {
  if (line.isEmpty) return null;

  final unixMatch =
      RegExp(r'([^\s]+) \(([^\)]+)\) at ([0-9a-fA-F:]{17})').firstMatch(line);
  if (unixMatch != null) {
    final name = unixMatch.group(1)!;
    final ip = unixMatch.group(2)!;
    final mac = unixMatch.group(3)!.toUpperCase();
    return NetworkDevice(
      ip: ip,
      mac: mac,
      vendor: _lookupVendor(mac),
      name: name == '?' ? 'Unknown' : name,
    );
  }

  final ipNeighMatch = RegExp(
    r'(\d+\.\d+\.\d+\.\d+)\s+dev\s+\S+\s+lladdr\s+([0-9a-fA-F:]{17})',
  ).firstMatch(line);
  if (ipNeighMatch != null) {
    final ip = ipNeighMatch.group(1)!;
    final mac = ipNeighMatch.group(2)!.toUpperCase();
    return NetworkDevice(
      ip: ip,
      mac: mac,
      vendor: _lookupVendor(mac),
      name: 'Unknown',
    );
  }

  final winMatch = RegExp(
    r'(\d+\.\d+\.\d+\.\d+)\s+([0-9a-fA-F-]{17})',
  ).firstMatch(line);
  if (winMatch != null) {
    final ip = winMatch.group(1)!;
    final mac = winMatch.group(2)!
        .replaceAll('-', ':')
        .toUpperCase();
    return NetworkDevice(
      ip: ip,
      mac: mac,
      vendor: _lookupVendor(mac),
      name: 'Unknown',
    );
  }

  return null;
}

String _lookupVendor(String mac) {
  final prefix = mac.replaceAll(':', '').toUpperCase();
  if (prefix.length >= 6) {
    final p = prefix.substring(0, 6);
    // Basic OUI to vendor mapping. Extend this map as needed for more
    // comprehensive lookups.
    const vendorMap = {
      '000C29': 'VMware',
      '0080C7': 'Cisco',
      'B827EB': 'Raspberry Pi',
      '00163E': 'Apple',
      'D850E6': 'Ubiquiti',
      '44D9E7': 'Huawei',
      '40BBBF': 'Intel',
    };
    return vendorMap[p] ?? 'Unknown';
  }
  return 'Unknown';
}
