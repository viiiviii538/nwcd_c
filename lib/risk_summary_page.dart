import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
          const SizedBox(height: 8),
          Text('$bullet 不要な開放ポートは攻撃の入口となります。'),
          const SizedBox(height: 8),
          Text('$bullet OSやソフトウェアの未更新は既知の脆弱性(CVE)悪用に繋がります。'),
          const SizedBox(height: 8),
          Text('$bullet デバイス/ソフトウェアのバージョンを把握し、脆弱性情報と照合することが重要です。'),
          const SizedBox(height: 8),
          Text('$bullet デフォルト/弱いパスワードの利用'),
          const SizedBox(height: 8),
          Text('$bullet 安全でないプロトコル (HTTP/Telnet) の使用'),
          const SizedBox(height: 8),
          Text('$bullet 管理インターフェースの外部公開'),
          const SizedBox(height: 8),
          Text('$bullet ネットワーク分割や監視体制の不足'),
          const SizedBox(height: 32),
          Text('通信先の国 一覧表示',
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
        ],
      ),
    );
  }
}
