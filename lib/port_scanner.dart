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

/// Simple port scanner utility.
class PortScanner {
  const PortScanner();

  /// Returns `true` if a TCP connection can be established to [host]:[port].
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

  /// Scans all [ports] on [host] and returns a map of port numbers to whether
  /// they are open.
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
