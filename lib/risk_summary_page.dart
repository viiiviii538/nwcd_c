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
        ],
      ),
    );
  }
}
