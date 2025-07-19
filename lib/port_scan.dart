class PortScanEntry {
  final String ipAddress;
  final String hostName;
  final String comment;

  const PortScanEntry({
    required this.ipAddress,
    required this.hostName,
    required this.comment,
  });
}

class PortScanResult {
  final int port;
  final String risk;
  final List<PortScanEntry> entries;

  const PortScanResult({
    required this.port,
    required this.risk,
    required this.entries,
  });
}

Future<List<PortScanResult>> portScan() async {
  await Future.delayed(const Duration(seconds: 1));
  return const [
    PortScanResult(
      port: 3389,
      risk: 'リモート接続が有効。乗っ取りリスクあり',
      entries: [
        PortScanEntry(
          ipAddress: '192.168.1.10',
          hostName: 'office-pc-01',
          comment: 'RDPが開放されています（リモート接続リスク）',
        ),
        PortScanEntry(
          ipAddress: '192.168.1.22',
          hostName: 'server-01',
          comment: '社内サーバにリモート接続可能。要対策',
        ),
      ],
    ),
    PortScanResult(
      port: 445,
      risk: 'ファイル共有サービス。ウイルス拡散リスク',
      entries: [
        PortScanEntry(
          ipAddress: '192.168.1.15',
          hostName: 'pc-sales01',
          comment: 'ファイル共有有効。ウイルス感染リスク高',
        ),
        PortScanEntry(
          ipAddress: '192.168.1.20',
          hostName: 'nas-office',
          comment: 'NASが445番開放。ランサム感染に注意',
        ),
      ],
    ),
    PortScanResult(
      port: 23,
      risk: '古いリモート操作。認証なし。',
      entries: [
        PortScanEntry(
          ipAddress: '192.168.1.30',
          hostName: 'iot-printer',
          comment: 'Telnet有効。旧式の設定で危険性あり',
        ),
      ],
    ),
  ];
}
