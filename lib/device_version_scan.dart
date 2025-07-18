class DeviceInfo {
  final String name;
  final String osVersion;
  final String firmwareVersion;
  final String softwareVersion;
  final bool vulnerable;

  const DeviceInfo({
    required this.name,
    required this.osVersion,
    required this.firmwareVersion,
    required this.softwareVersion,
    required this.vulnerable,
  });
}

Future<List<DeviceInfo>> deviceVersionScan() async {
  // In a real implementation this function would scan the network and
  // query each device for its firmware and software versions. For this
  // example we just return a simulated list of devices.
  await Future.delayed(const Duration(seconds: 1));
  return const [
    DeviceInfo(
      name: 'Router',
      osVersion: '1.0.0',
      firmwareVersion: '2.0.0',
      softwareVersion: '3.0.0',
      vulnerable: false,
    ),
    DeviceInfo(
      name: 'Camera',
      osVersion: '5.0.1',
      firmwareVersion: '1.2.3',
      softwareVersion: '4.5.6',
      vulnerable: true,
    ),
    DeviceInfo(
      name: 'NAS',
      osVersion: '2.5.0',
      firmwareVersion: '2.5.0',
      softwareVersion: '2.5.0',
      vulnerable: false,
    ),
  ];
}
