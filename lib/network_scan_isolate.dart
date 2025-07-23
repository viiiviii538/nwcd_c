import 'dart:isolate';

import 'network_scanner.dart';

/// Entry point for spawning an isolate that runs [scanNetwork].
///
/// The isolate sends the list of discovered devices as a `List<Map<String,
/// String>>` back through the provided [SendPort].
void networkScanIsolate(SendPort sendPort) {
  () async {
    final devices = await scanNetwork();
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
