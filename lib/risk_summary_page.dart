import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;

class _CountryConnection {
  final String country;
  final int count;

  _CountryConnection(this.country, this.count);
}

/// Static summary of common network security risks highlighted in README.
class RiskSummaryPage extends StatelessWidget {
  const RiskSummaryPage({super.key});

  static final List<_CountryConnection> _sampleData = [
    _CountryConnection('日本', 134),
    _CountryConnection('アメリカ', 27),
    _CountryConnection('ロシア', 2),
  ];

  List<charts.Series<_CountryConnection, String>> _createSeries() {
    return [
      charts.Series<_CountryConnection, String>(
        id: 'Connections',
        domainFn: (d, _) => d.country,
        measureFn: (d, _) => d.count,
        data: _sampleData,
        labelAccessorFn: (d, _) => '${d.country}: ${d.count}',
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bullet = '\u2022';
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text(
            'リスク要約',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 16),
          Text('$bullet 無許可のネットワークスキャンは違法となる可能性があります。'),
          Text('$bullet 不要な開放ポートは攻撃の入口となります。'),
          Text(
            '$bullet OSやソフトウェアの未更新は既知の脆弱性(CVE)悪用に繋がります。',
          ),
          Text(
            '$bullet デバイス/ソフトウェアのバージョンを把握し、脆弱性情報と照合することが重要です。',
          ),
          Text('$bullet デフォルト/弱いパスワードの利用'),
          Text('$bullet 安全でないプロトコル (HTTP/Telnet) の使用'),
          Text('$bullet 管理インターフェースの外部公開'),
          Text('$bullet ネットワーク分割や監視体制の不足'),
          Text('$bullet 危険なポートが開いている機器のリスト表示'),
          Text('$bullet 通信量が異常な機器のランキング表示'),
          const SizedBox(height: 32),
          Text('$bullet 通信先の国 一覧表示',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: charts.PieChart(
              _createSeries(),
              animate: false,
              defaultRenderer: charts.ArcRendererConfig(
                arcRendererDecorators: [charts.ArcLabelDecorator()],
              ),
            ),
          ),
          const SizedBox(height: 16),
          DataTable(
            columns: const [
              DataColumn(label: Text('国名')),
              DataColumn(label: Text('通信回数（件）')),
            ],
            rows: _sampleData
                .map(
                  (d) => DataRow(cells: [
                    DataCell(Text(d.country)),
                    DataCell(Text('${d.count}')),
                  ]),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          Text(
            '危険な通信デモ',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          DataTable(
            columns: const [
              DataColumn(label: Text('宛先ホスト名/IP')),
              DataColumn(label: Text('通信種別')),
              DataColumn(label: Text('暗号化状態')),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('test.example.com')),
                DataCell(Text('HTTP')),
                DataCell(Text('暗号化なし')),
              ]),
              DataRow(cells: [
                DataCell(Text('printer.local')),
                DataCell(Text('TELNET')),
                DataCell(Text('暗号化なし')),
              ]),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.black12,
            child: const Text(
              'GET / HTTP/1.1\nHost: test.example.com',
              style: TextStyle(fontFamily: 'monospace'),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '危険なポートが開いている機器',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          DataTable(
            columns: const [
              DataColumn(label: Text('IPアドレス')),
              DataColumn(label: Text('機器名')),
              DataColumn(label: Text('開いている危険ポート')),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('192.168.0.12')),
                DataCell(Text('PC-A')),
                DataCell(Text('3389, 445')),
              ]),
              DataRow(cells: [
                DataCell(Text('192.168.0.34')),
                DataCell(Text('古いNAS装置')),
                DataCell(Text('23（TELNET）')),
              ]),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '通信量が異常な機器',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          DataTable(
            columns: const [
              DataColumn(label: Text('IPアドレス')),
              DataColumn(label: Text('デバイス名')),
              DataColumn(label: Text('通信量（MB/分）')),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('192.168.0.12')),
                DataCell(Text('PC-A')),
                DataCell(Text('327')),
              ]),
              DataRow(cells: [
                DataCell(Text('192.168.0.21')),
                DataCell(Text('NAS-Server')),
                DataCell(Text('215')),
              ]),
              DataRow(cells: [
                DataCell(Text('192.168.0.3')),
                DataCell(Text('不明な機器')),
                DataCell(Text('200')),
              ]),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '⚠️ 異常検出',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            '同じIPに異なるMACアドレスが複数存在します。\n通信なりすまし（ARPスプーフィング）のリスクがあります。',
          ),
          const SizedBox(height: 8),
          DataTable(
            columns: const [
              DataColumn(label: Text('IPアドレス')),
              DataColumn(label: Text('MACアドレス')),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('192.168.0.15')),
                DataCell(Text('AA:BB:CC:DD:EE:01')),
              ]),
              DataRow(cells: [
                DataCell(Text('192.168.0.15')),
                DataCell(Text('AA:BB:CC:DD:EE:99')),
              ]),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'ルーターが複数稼働（DHCP重複検出）',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            '検出結果：DHCPサーバが複数存在しています（想定外のルーター稼働中）',
          ),
          const SizedBox(height: 8),
          DataTable(
            columns: const [
              DataColumn(label: Text('IPアドレス')),
              DataColumn(label: Text('機器種別')),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('192.168.0.1')),
                DataCell(Text('メインルーター')),
              ]),
              DataRow(cells: [
                DataCell(Text('192.168.0.254')),
                DataCell(Text('未知の家庭用ルーター')),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
