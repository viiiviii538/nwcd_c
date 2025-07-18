import 'dart:io';

/// Result of scanning a single port.
class PortScanResult {
  /// The port number that was scanned.
  final int port;

  /// Whether this port is considered dangerous.
  final bool dangerous;

  PortScanResult(this.port, {required this.dangerous});
}

/// Set of ports that are considered dangerous.
const Set<int> dangerousPorts = {3389, 445};

/// Scanner used by the app. It can be replaced with a fake implementation
/// in the tests.
class PortScanner {
  const PortScanner();

  /// Checks whether [port] on [host] accepts TCP connections.
  Future<bool> isPortOpen(
    String host,
    int port, {
    Duration timeout = const Duration(seconds: 1),
  }) async {
    try {
      final socket = await Socket.connect(host, port, timeout: timeout);
      socket.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Scans each port in [ports] and returns a map indicating whether the port
  /// is open or not.
  Future<Map<int, bool>> scanPorts(
    String host,
    List<int> ports, {
    Duration timeout = const Duration(seconds: 1),
  }) async {
    final results = <int, bool>{};
    for (final port in ports) {
      results[port] = await isPortOpen(host, port, timeout: timeout);
    }
    return results;
  }
}

/// Converts the results from [PortScanner.scanPorts] into a list of
/// [PortScanResult] objects containing additional danger information.
List<PortScanResult> mapToScanResults(Map<int, bool> scanMap) {
  final results = <PortScanResult>[];
  for (final entry in scanMap.entries) {
    if (entry.value) {
      results.add(
        PortScanResult(entry.key, dangerous: dangerousPorts.contains(entry.key)),
      );
    }
  }
  return results;
}
