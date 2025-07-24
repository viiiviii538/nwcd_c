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
          Text('$bullet 以下は無許可スキャンで得られる可能性のある情報例です:'),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black12,
              border: Border.all(color: Colors.grey),
            ),
            child: const Text(
              '192.168.1.10:22/tcp open ssh\n192.168.1.10:80/tcp open http',
              style: TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }
}
