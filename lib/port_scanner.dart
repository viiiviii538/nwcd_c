import 'dart:async';
import 'dart:io';

class PortScanner {
  const PortScanner();

  Future<bool> isPortOpen(String host, int port,
      {Duration timeout = const Duration(seconds: 1)}) async {
    try {
      final socket = await Socket.connect(host, port, timeout: timeout);
      socket.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<Map<int, bool>> scanPorts(String host, List<int> ports,
      {Duration timeout = const Duration(seconds: 1)}) async {
    final results = <int, bool>{};
    for (final port in ports) {
      results[port] = await isPortOpen(host, port, timeout: timeout);
    }
    return results;
  }
}
