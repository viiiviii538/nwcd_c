import 'dart:async';

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
}

Future<String> checkOpenPorts() async {
  await Future.delayed(const Duration(seconds: 1));
  return 'Open ports: 80, 443';
}
