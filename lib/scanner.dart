import 'dart:async';

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

Future<String> scanDeviceVersion() async {
  await Future.delayed(const Duration(seconds: 1));
  return 'Device version: 1.0';
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
