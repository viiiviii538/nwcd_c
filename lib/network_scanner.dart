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
    final result = await Process.run('arp', ['-a']);
    if (result.exitCode != 0) return [];
    final output = result.stdout as String;
    final devices = <NetworkDevice>[];
    for (final line in output.split('\n')) {
      final match =
          RegExp(r'([^\s]+) \(([^\)]+)\) at ([0-9a-fA-F:]{17})').firstMatch(line);
      if (match != null) {
        final name = match.group(1)!;
        final ip = match.group(2)!;
        final mac = match.group(3)!.toUpperCase();
        devices.add(NetworkDevice(
          ip: ip,
          mac: mac,
          vendor: _lookupVendor(mac),
          name: name == '?' ? 'Unknown' : name,
        ));
      }
    }
    return devices;
  } catch (_) {
    return [];
  }
}

String _lookupVendor(String mac) {
  final prefix = mac.replaceAll(':', '').toUpperCase();
  if (prefix.length >= 6) {
    final p = prefix.substring(0, 6);
    const vendorMap = {
      '000C29': 'VMware',
      '0080C7': 'Cisco',
      'B827EB': 'Raspberry Pi',
    };
    return vendorMap[p] ?? 'Unknown';
  }
  return 'Unknown';
}
