class DeviceInfo {
  final String ip;
  final String name;
  final String osVersion;
  final bool osUpdatePending;
  final bool rdpPortOpen;
  final bool cveVulnerable;

  const DeviceInfo({
    required this.ip,
    required this.name,
    required this.osVersion,
    required this.osUpdatePending,
    required this.rdpPortOpen,
    required this.cveVulnerable,
  });
}

Future<List<DeviceInfo>> deviceVersionScan() async {
  // NOTE: In a production environment this function would scan the local
  // network, query devices for version information and check them against
  // known vulnerability databases. This demo returns fixed values so that the
  // UI can display an example result without performing real network access.
  await Future.delayed(const Duration(seconds: 1));
  return const [
    DeviceInfo(
      ip: '192.168.0.2',
      name: 'PC-A',
      osVersion: 'Windows 10 20H2',
      osUpdatePending: false,
      rdpPortOpen: true,
      cveVulnerable: false,
    ),
    DeviceInfo(
      ip: '192.168.0.7',
      name: 'PC-B',
      osVersion: 'Windows 8',
      osUpdatePending: true,
      rdpPortOpen: false,
      cveVulnerable: false,
    ),
    DeviceInfo(
      ip: '192.168.0.9',
      name: 'IoT-Camera',
      osVersion: '1.3.0',
      osUpdatePending: false,
      rdpPortOpen: false,
      cveVulnerable: true,
    ),
  ];
}
