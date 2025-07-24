import 'package:flutter/material.dart';

/// Static summary of common network security risks highlighted in README.
class RiskSummaryPage extends StatelessWidget {
  const RiskSummaryPage({super.key});

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
        ],
      ),
    );
  }
}
