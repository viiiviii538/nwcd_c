import 'dart:io';

/// Represents a connection from [from] interface/device to [to] device.
class TopologyLink {
  final String from;
  final String to;

  TopologyLink({required this.from, required this.to});
}

/// Attempts to discover network topology using the `lldpctl` command.
///
/// Returns a list of [TopologyLink] describing the connections. If `lldpctl`
/// is not available or fails, an empty list is returned.
Future<List<TopologyLink>> scanTopology({
  Future<ProcessResult> Function()? runLldpctl,
}) async {
  final run = runLldpctl ?? () => Process.run('lldpctl', []);
  try {
    final result = await run();
    if (result.exitCode != 0) return [];
    return _parseLldpctl(result.stdout as String);
  } catch (_) {
    return [];
  }
}

/// Parses output from `lldpctl` into a list of [TopologyLink].
List<TopologyLink> _parseLldpctl(String output) {
  final links = <TopologyLink>[];
  String? currentInterface;
  for (final line in output.split('\\n')) {
    final trimmed = line.trim();
    final interfaceMatch = RegExp(r'^Interface:\s*([^,]+)').firstMatch(trimmed);
    if (interfaceMatch != null) {
      currentInterface = interfaceMatch.group(1)!.trim();
      continue;
    }
    final sysNameMatch = RegExp(r'^SysName:\s*(.+)$').firstMatch(trimmed);
    if (sysNameMatch != null && currentInterface != null) {
      links.add(TopologyLink(from: currentInterface, to: sysNameMatch.group(1)!));
      currentInterface = null;
    }
  }
  return links;
}

/// Visible for testing only.
List<TopologyLink> parseLldpctlForTest(String output) => _parseLldpctl(output);
