import 'dart:isolate';

import 'network_scanner.dart';

/// Signature for a function that scans the network.
typedef ScanNetworkFn = Future<List<NetworkDevice>> Function();

/// Entry point for spawning an isolate that runs a network scan.
///
/// The [message] may be either a [SendPort] or a `[SendPort, ScanNetworkFn]`
/// tuple. The isolate sends the list of discovered devices as a
/// `List<Map<String, String>>` back through the provided [SendPort].
void networkScanIsolate(dynamic message) {
  late final SendPort sendPort;
  ScanNetworkFn scanFn = scanNetwork;

  if (message is SendPort) {
    sendPort = message;
  } else if (message is List && message.isNotEmpty && message[0] is SendPort) {
    sendPort = message[0] as SendPort;
    if (message.length > 1 && message[1] is Function) {
      scanFn = message[1] as ScanNetworkFn;
    }
  } else {
    throw ArgumentError('Invalid message for networkScanIsolate');
  }

  () async {
    final devices = await scanFn();
    final serialized = devices
        .map((d) => {
              'ip': d.ip,
              'mac': d.mac,
              'vendor': d.vendor,
              'name': d.name,
            })
        .toList();
    sendPort.send(serialized);
    Isolate.exit();
  }();
}
