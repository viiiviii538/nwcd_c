import 'dart:isolate';

import 'network_scanner.dart';

/// Entry point for spawning an isolate that runs [scanNetwork].
///
/// The isolate sends the list of discovered [NetworkDevice] back through the
/// provided [SendPort].
void networkScanIsolate(SendPort sendPort) {
  () async {
    final devices = await scanNetwork();
    sendPort.send(devices);
    Isolate.exit();
  }();
}
