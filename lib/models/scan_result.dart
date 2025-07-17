import 'dart:convert';

class ScanResult {
  final Map<String, List<int>> dangerPorts;
  final Map<String, int> openPortCount;
  final Map<String, bool> netbios;
  final Map<String, bool> smbv1;
  final Map<String, bool> upnp;
  final Map<String, String> geoip;
  final double? intlTrafficRatio;
  final double? httpRatio;
  final double? dnsFailRate;
  final List<String> externalCommWarnings;
  final Map<String, String> ssl;
  final bool? defenderEnabled;
  final bool? firewallEnabled;
  final String osVersion;
  final bool? dhcp;
  final bool? arpSpoofing;
  final bool? ipConflict;
  final double? unknownMacRatio;
  final int? deviceCount;

  ScanResult({
    required this.dangerPorts,
    required this.openPortCount,
    required this.netbios,
    required this.smbv1,
    required this.upnp,
    required this.geoip,
    required this.intlTrafficRatio,
    required this.httpRatio,
    required this.dnsFailRate,
    required this.externalCommWarnings,
    required this.ssl,
    required this.defenderEnabled,
    required this.firewallEnabled,
    required this.osVersion,
    required this.dhcp,
    required this.arpSpoofing,
    required this.ipConflict,
    required this.unknownMacRatio,
    required this.deviceCount,
  });

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      dangerPorts: (json['danger_ports'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, List<int>.from(v)),
          ) ??
          <String, List<int>>{},
      openPortCount: (json['open_port_count'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as int),
          ) ??
          <String, int>{},
      netbios: (json['netbios'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as bool),
          ) ??
          <String, bool>{},
      smbv1: (json['smbv1'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as bool),
          ) ??
          <String, bool>{},
      upnp: (json['upnp'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as bool),
          ) ??
          <String, bool>{},
      geoip: (json['geoip'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as String),
          ) ??
          <String, String>{},
      intlTrafficRatio:
          (json['intl_traffic_ratio'] as num?)?.toDouble(),
      httpRatio: (json['http_ratio'] as num?)?.toDouble(),
      dnsFailRate: (json['dns_fail_rate'] as num?)?.toDouble(),
      externalCommWarnings: (json['external_comm_warnings'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          <String>[],
      ssl: (json['ssl'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as String),
          ) ??
          <String, String>{},
      defenderEnabled: json['defender_enabled'] as bool?,
      firewallEnabled: json['firewall_enabled'] as bool?,
      osVersion: json['os_version']?.toString() ?? '',
      dhcp: json['dhcp'] as bool?,
      arpSpoofing: json['arp_spoofing'] as bool?,
      ipConflict: json['ip_conflict'] as bool?,
      unknownMacRatio: (json['unknown_mac_ratio'] as num?)?.toDouble(),
      deviceCount: json['device_count'] as int?,
    );
  }

  static ScanResult fromJsonString(String source) {
    final data = jsonDecode(source) as Map<String, dynamic>;
    return ScanResult.fromJson(data);
  }
}
