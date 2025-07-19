import 'dart:async';

Future<String> scanDeviceVersion() async {
  await Future.delayed(const Duration(seconds: 1));
  return 'Device version: 1.0';
}

Future<String> checkOpenPorts() async {
  await Future.delayed(const Duration(seconds: 1));
  return 'Open ports: 80, 443';
}
