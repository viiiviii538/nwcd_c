class DeviceInfo {
  final String ip;
  String? host;
  String? deviceName;
  String? osVersion;
  List<int>? openPorts;
  List<String>? vulnerabilities;

  DeviceInfo({
    required this.ip,
    this.host,
    this.deviceName,
    this.osVersion,
    this.openPorts,
    this.vulnerabilities,
  });

  @override
  String toString() {
    final buffer = StringBuffer('IP: $ip');
    if (deviceName != null) buffer.write('\nDevice: $deviceName');
    if (osVersion != null) buffer.write('\nOS: $osVersion');
    if (openPorts != null && openPorts!.isNotEmpty) {
      buffer.write('\nOpen ports: ${openPorts!.join(', ')}');
    }
    if (vulnerabilities != null && vulnerabilities!.isNotEmpty) {
      buffer.write('\nVulnerabilities:\n  - ' + vulnerabilities!.join('\n  - '));
    }
    return buffer.toString();
  }
}
