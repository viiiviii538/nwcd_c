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
    final subnets = await getLocalSubnets();
    final devices = <NetworkDevice>[];
    for (final subnet in subnets) {
      final nmapOutput = await _runNmap(subnet);
      if (nmapOutput != null) {
        devices.addAll(_parseNmapOutput(nmapOutput));
      } else {
        devices.addAll(await _pingSweep(subnet));
      }
    }
    final unique = <String, NetworkDevice>{};
    for (final d in devices) {
      unique[d.ip] = d;
    }
    return unique.values.toList();
  } catch (_) {
    return [];
  }
}

Future<String?> _runNmap(String subnet) async {
  try {
    final result = await Process.run('nmap', ['-sn', subnet]);
    if (result.exitCode == 0) {
      return result.stdout as String;
    }
  } on ProcessException {
    // ignore
  }
  return null;
}

List<NetworkDevice> _parseNmapOutput(String output) {
  final devices = <NetworkDevice>[];
  for (final line in output.split('\n')) {
    final device = _parseDeviceLine(line.trim());
    if (device != null) {
      devices.add(device);
    }
  }
  return devices;
}

Future<List<NetworkDevice>> _pingSweep(String subnet) async {
  final parts = subnet.split('/');
  if (parts.length != 2) return [];
  final baseIp = parts[0];
  final prefix = int.tryParse(parts[1]!) ?? 24;
  final start = _ipToInt(calculateNetwork(baseIp, prefix));
  final count = 1 << (32 - prefix);
  final tasks = <Future<void>>[];
  for (var i = 1; i < count - 1; i++) {
    tasks.add(_pingAddress(_intToIp(start + i)));
  }
  await Future.wait(tasks);
  final arpEntries = await _readArpTable();
  return arpEntries.where((e) {
    final ipInt = _ipToInt(e.ip);
    return ipInt >= start && ipInt < start + count;
  }).toList();
}

Future<void> _pingAddress(String ip) async {
  try {
    if (Platform.isWindows) {
      await Process.run('ping', ['-n', '1', '-w', '1000', ip]);
    } else {
      await Process.run('ping', ['-c', '1', '-W', '1', ip]);
    }
  } catch (_) {}
}

Future<List<NetworkDevice>> _readArpTable() async {
  final result = await Process.run('arp', ['-a']);
  if (result.exitCode != 0) return [];
  final output = result.stdout as String;
  final devices = <NetworkDevice>[];
  final unix = RegExp(r'([^\s]+) \(([^)]+)\) at ([0-9A-Fa-f:]{17})');
  final windows = RegExp(r'\s*([0-9.]+)\s+([0-9A-Fa-f:-]{17})\s');
  for (final line in output.split('\n')) {
    var m = unix.firstMatch(line);
    if (m != null) {
      final name = m.group(1)!;
      final ip = m.group(2)!;
      final mac = m.group(3)!.toUpperCase();
      devices.add(NetworkDevice(
        ip: ip,
        mac: mac,
        vendor: _lookupVendor(mac),
        name: name == '?' ? 'Unknown' : name,
      ));
      continue;
    }
    m = windows.firstMatch(line);
    if (m != null) {
      final ip = m.group(1)!;
      final mac = m.group(2)!.replaceAll('-', ':').toUpperCase();
      devices.add(NetworkDevice(
        ip: ip,
        mac: mac,
        vendor: _lookupVendor(mac),
        name: 'Unknown',
      ));
    }
  }
  return devices;
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

/// Returns a list of local network subnets in CIDR notation (e.g. 192.168.0.0/24).
Future<List<String>> getLocalSubnets() async {
  final subnets = <String>{};
  try {
    if (Platform.isWindows) {
      final result = await Process.run('ipconfig', []);
      if (result.exitCode != 0) return [];
      final lines = (result.stdout as String).split(RegExp(r'\r?\n'));
      String? ip;
      String? mask;
      for (final line in lines) {
        final ipMatch =
            RegExp(r'IPv4 Address[^:]*: ([0-9.]+)').firstMatch(line);
        if (ipMatch != null) ip = ipMatch.group(1);
        final maskMatch = RegExp(r'Subnet Mask[^:]*: ([0-9.]+)').firstMatch(line);
        if (maskMatch != null) mask = maskMatch.group(1);
        if (ip != null && mask != null) {
          final prefix = maskToPrefix(mask);
          final network = calculateNetwork(ip, prefix);
          subnets.add('$network/$prefix');
          ip = null;
          mask = null;
        }
      }
    } else {
      // Prefer the `ip` command on Unix-like systems
      ProcessResult result;
      try {
        result = await Process.run('ip', ['-o', '-f', 'inet', 'addr', 'show']);
      } on ProcessException {
        result = ProcessResult(0, 1, '', '');
      }
      if (result.exitCode == 0) {
        final output = result.stdout as String;
        for (final line in output.split('\n')) {
          final match = RegExp(r'inet ([0-9.]+)/([0-9]+)').firstMatch(line);
          if (match != null) {
            final ip = match.group(1)!;
            final prefix = int.parse(match.group(2)!);
            final network = calculateNetwork(ip, prefix);
            subnets.add('$network/$prefix');
          }
        }
      } else {
        final resultIfconfig = await Process.run('ifconfig', []);
        if (resultIfconfig.exitCode != 0) return [];
        final output = resultIfconfig.stdout as String;
        final regex =
            RegExp(r'inet ([0-9.]+) +netmask +(0x[0-9a-fA-F]+|[0-9.]+)');
        for (final match in regex.allMatches(output)) {
          final ip = match.group(1)!;
          final maskRaw = match.group(2)!;
          final mask = maskRaw.startsWith('0x')
              ? _hexMaskToDotted(maskRaw)
              : maskRaw;
          final prefix = maskToPrefix(mask);
          final network = calculateNetwork(ip, prefix);
          subnets.add('$network/$prefix');
        }
      }
    }
  } catch (_) {
    return [];
  }
  return subnets.toList();
}

/// Converts a dotted decimal subnet mask (e.g. 255.255.255.0) to prefix length.
int maskToPrefix(String mask) {
  int prefix = 0;
  for (final part in mask.split('.')) {
    var value = int.tryParse(part) ?? 0;
    for (int i = 0; i < 8; i++) {
      if ((value & 0x80) != 0) prefix++;
      value <<= 1;
    }
  }
  return prefix;
}

/// Calculates the network address for [ip] with the given [prefix].
String calculateNetwork(String ip, int prefix) {
  final parts = ip.split('.').map(int.parse).toList();
  var ipInt = (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8) | parts[3];
  final mask = prefix == 0
      ? 0
      : (~((1 << (32 - prefix)) - 1) & 0xFFFFFFFF);
  final network = ipInt & mask;
  final bytes = [
    (network >> 24) & 0xFF,
    (network >> 16) & 0xFF,
    (network >> 8) & 0xFF,
    network & 0xFF,
  ];
  return bytes.join('.');
}

String _hexMaskToDotted(String hex) {
  var value = int.parse(hex.startsWith('0x') ? hex.substring(2) : hex, radix: 16);
  final bytes = [
    (value >> 24) & 0xFF,
    (value >> 16) & 0xFF,
    (value >> 8) & 0xFF,
    value & 0xFF,
  ];
  return bytes.join('.');
}

int _ipToInt(String ip) {
  final parts = ip.split('.').map(int.parse).toList();
  return (parts[0] << 24) |
      (parts[1] << 16) |
      (parts[2] << 8) |
      parts[3];
}

String _intToIp(int val) {
  return [
    (val >> 24) & 0xFF,
    (val >> 16) & 0xFF,
    (val >> 8) & 0xFF,
    val & 0xFF,
  ].join('.');
}
