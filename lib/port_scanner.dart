import 'dart:io';

/// Result of scanning a single port. Only open ports are returned from
/// [PortScanner.scanPorts].
class PortScanResult {
  /// The port number that was scanned.
  final int port;

  /// Whether this port is considered dangerous.
  final bool dangerous;

  const PortScanResult(this.port, {required this.dangerous});
}

/// Set of ports that are considered dangerous.
const Set<int> dangerousPorts = {3389, 445};

/// Provides simple port scanning functionality used by the application and
/// tests.
class PortScanner {
  const PortScanner();

  /// Returns `true` if the given [port] on [host] accepts a TCP connection.
  Future<bool> isPortOpen(
    String host,
    int port, {
    Duration timeout = const Duration(milliseconds: 500),
  }) async {
    try {
      final socket = await Socket.connect(host, port, timeout: timeout);
      socket.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Attempts to connect to each port in [ports] on [host] and returns a map of
  /// ports to a boolean indicating whether the port was open. Only open ports
  /// are returned via [PortScanResult] for the UI.
  Future<Map<int, bool>> scanPorts(
    String host,
    List<int> ports, {
    Duration timeout = const Duration(milliseconds: 500),
  }) async {
    final results = <int, bool>{};
    for (final port in ports) {
      results[port] = await isPortOpen(host, port, timeout: timeout);
    }
    return results;
  }
}
