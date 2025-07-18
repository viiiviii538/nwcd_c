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

/// Attempts to connect to each port in [ports] on [host] and returns
/// a list of the ports that were open. Each returned item also indicates
/// whether the port is considered dangerous.
Future<List<PortScanResult>> scanPorts(
  String host,
  List<int> ports, {
  Duration timeout = const Duration(milliseconds: 500),
}) async {
  final results = <PortScanResult>[];
  for (final port in ports) {
    try {
      final socket =
          await Socket.connect(host, port, timeout: timeout);
      socket.destroy();
      results.add(
        PortScanResult(port, dangerous: dangerousPorts.contains(port)),
      );
    } catch (_) {
      // Closed or unreachable port, ignore.
    }
  }
  return results;
}
