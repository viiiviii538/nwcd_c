import 'package:flutter/material.dart';

class DummyTabPage extends StatelessWidget {
  const DummyTabPage({super.key});

  Table _buildTable(List<Map<String, String>> rows) {
    return Table(
      border: TableBorder.all(color: Colors.grey),
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: FixedColumnWidth(80),
        2: FlexColumnWidth(),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade300),
          children: const [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('項目', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('結果', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('説明', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        for (final row in rows)
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(row['項目'] ?? ''),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(row['結果'] ?? ''),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(row['説明'] ?? ''),
              ),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const data = {
      'ネットワーク開放リスク': [
        {
          '項目': '危険ポートの個数（danger_ports）',
          '結果': '1（445番）',
          '説明': '社内NASの設定でSMBが外部にも開放されている状態。'
        },
        {
          '項目': '開いているポート数（open_port_count）',
          '結果': '12個',
          '説明': 'ファイルサーバや複合機の管理ポートも含まれる。'
        },
        {
          '項目': 'NetBIOS警告（netbios）',
          '結果': '❌ 有効',
          '説明': '古いWindows共有機能が残っている。'
        },
        {
          '項目': 'SMBv1利用有無（smbv1）',
          '結果': '❌ 利用中',
          '説明': '社内NASが古くSMBv1で動作。非常に危険。'
        },
        {
          '項目': 'UPnPの有無（upnp）',
          '結果': '✅ 無効',
          '説明': '問題なし。'
        },
      ],
      '外部通信リスク': [
        {
          '項目': 'GeoIP国情報（geoip）',
          '結果': '日本 / アメリカ / 中国（1件）',
          '説明': '通信先のうち1件が中国サーバ。広告SDKなどの可能性あり。'
        },
        {
          '項目': '海外通信比率（intl_traffic_ratio）',
          '結果': '18%',
          '説明': '半分以上が日本国内通信。'
        },
        {
          '項目': 'HTTP通信の比率（http_ratio）',
          '結果': '25%',
          '説明': '社員PCの一部アプリがHTTPのみで通信している。'
        },
        {
          '項目': 'DNS失敗率（dns_fail_rate）',
          '結果': '2%',
          '説明': '軽微な失敗率。特に問題なし。'
        },
        {
          '項目': '外部通信警告',
          '結果': '1件',
          '説明': '不審な国外IPとの通信履歴あり（IP: 185.221.xx.xx）'
        },
      ],
      'SSL・暗号化の状態': [
        {
          '項目': 'SSL証明書の状態（ssl）',
          '結果': '一部無効',
          '説明': '社員が使っている外部クラウド（不明）で自己署名証明書あり。'
        },
        {
          '項目': 'HTTP通信の比率',
          '結果': '25%',
          '説明': '上記と同様。TLS未対応の外部アプリ通信。'
        },
      ],
      'セキュリティ対策状況': [
        {
          '項目': 'Windows Defender状態（defender_enabled）',
          '結果': '✅ 有効',
          '説明': '全端末で有効化確認済み。'
        },
        {
          '項目': 'ファイアウォール状態（firewall_enabled）',
          '結果': '✅ 有効',
          '説明': '社内ルールによりポリシー制御済み。'
        },
        {
          '項目': 'OSバージョン',
          '結果': 'Windows 10 Pro (22H2)',
          '説明': '全端末がサポート対象の最新版。'
        },
        {
          '項目': 'DHCP警告',
          '結果': '❌ あり',
          '説明': '古い無線ルーターが誤ってDHCP提供中。通信干渉の恐れあり。'
        },
      ],
      'ローカルネットワークの健全性': [
        {
          '項目': 'ARPスプーフィング警告',
          '結果': '❌ 検出',
          '説明': '社内に不正ARP応答が確認された履歴あり。攻撃の可能性。'
        },
        {
          '項目': 'IPアドレス競合',
          '結果': '❌ あり',
          '説明': '1端末で競合履歴あり（複合機と被り）。'
        },
        {
          '項目': '未知MACアドレス比率',
          '結果': '5%',
          '説明': '来客用Wi-Fiに一時的な端末接続あり。'
        },
        {
          '項目': '検出デバイス数',
          '結果': '36台',
          '説明': '社員数と一致しているため問題なし。'
        },
      ],
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final entry in data.entries) ...[
            Text(
              entry.key,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildTable(entry.value as List<Map<String, String>>),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }
}
