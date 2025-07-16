import 'package:flutter/material.dart';

class ScanResultPage extends StatelessWidget {
  const ScanResultPage({super.key});

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(description),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              '結果を表示',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('診断結果ページ'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('ネットワーク開放リスク'),
            _buildItem('危険ポートの個数（danger_ports）',
                'RDP（3389）やSMB（445）などのポートは、不正アクセスやウイルス感染の経路になります。開放されたままだと、外部からの攻撃にさらされるリスクが高くなります。'),
            _buildItem('開いているポート数（open_port_count）',
                '使用していないポートが多数開いていると、攻撃対象が増えることになります。必要最小限のポート以外は閉じるのがセキュリティの基本です。'),
            _buildItem('NetBIOS警告（netbios）',
                'NetBIOSは古いファイル共有プロトコルで、外部からネットワーク名や共有情報を覗かれる原因になります。使用していない場合は無効化が推奨されます。'),
            _buildItem('SMBv1利用有無（smbv1）',
                'SMBv1は脆弱性が多く、WannaCryなどのランサムウェアに悪用された過去があります。使用している場合は即時無効化を推奨します。'),
            _buildItem('UPnPの有無（upnp）',
                'UPnPはルーターや機器の設定を自動で変更できる便利な機能ですが、外部からの不正アクセスに悪用されるリスクがあります。セキュリティ重視の環境では無効化が望まれます。'),

            _buildSectionTitle('外部通信リスク'),
            _buildItem('GeoIP国情報（geoip）',
                '社内端末がどの国と通信しているかを解析します。中国・ロシアなど一部の国との通信は、情報漏えいや不正アクセスの可能性があるため注意が必要です。'),
            _buildItem('海外通信比率（intl_traffic_ratio）',
                '全通信の中で、海外IPとの通信が占める割合です。正当な理由がない場合は、情報漏えいや不審な外部接続の兆候と考えられます。'),
            _buildItem('HTTP通信の比率（http_ratio）',
                '暗号化されていないHTTP通信の割合です。HTTP通信が多い場合、通信内容が盗聴・改ざんされる可能性があります。'),
            _buildItem('DNS失敗率（dns_fail_rate）',
                '通信先の名前解決が失敗する割合を示します。フィッシングサイトや誤設定、マルウェア通信などの兆候である可能性があります。'),
            _buildItem('外部通信警告（external_comm_warnings）',
                '通信先が危険と判断された場合に出る警告です。通信内容の監視や、UTMによる外部接続の制御が推奨されます。'),

            _buildSectionTitle('SSL・暗号化の状態'),
            _buildItem('SSL証明書の状態（ssl）',
                'SSL証明書が有効かどうかを判定します。無効・期限切れ・自己署名などの場合、通信内容の盗聴やなりすましのリスクがあります。'),
            _buildItem('HTTP通信の比率（http_ratio）',
                '暗号化されていないHTTP通信の割合です。HTTPSが使われていない場合、個人情報や機密情報が漏洩する可能性があります。'),

            _buildSectionTitle('セキュリティ対策状況'),
            _buildItem('Windows Defender状態（defender_enabled）',
                'Windows標準のウイルス対策機能が有効かどうかを確認します。無効の場合、マルウェアやスパイウェアの侵入リスクが高まります。'),
            _buildItem('ファイアウォール状態（firewall_enabled）',
                '外部からの通信を遮断するファイアウォールが有効かどうかを示します。無効の場合、ネットワークを通じた不正アクセスの危険があります。'),
            _buildItem('OSバージョン（os_version / windows_version）',
                'Windowsのバージョンを確認し、サポート切れや脆弱なバージョンでないかを判定します。古いOSはセキュリティパッチが適用されず、攻撃対象になりやすいです。'),
            _buildItem('DHCP警告（dhcp）',
                '社内ネットワークに複数のDHCPサーバが存在する場合、IPアドレスの割り当てミスや通信不具合の原因になります。意図しない機器がDHCPを提供していないか確認が必要です。'),

            _buildSectionTitle('ローカルネットワークの健全性'),
            _buildItem('ARPスプーフィング警告（arp_spoofing）',
                'ARPスプーフィングは、同一ネットワーク内の通信を乗っ取る攻撃手法です。攻撃者が通信を盗聴・改ざんできるため、非常に危険です。'),
            _buildItem('IPアドレス競合の有無（ip_conflict）',
                '同一ネットワーク内で同じIPアドレスを持つ端末が複数存在すると、通信が不安定になります。機器の誤動作やネットワークの停止につながる恐れがあります。'),
            _buildItem('未知MACアドレス比率（unknown_mac_ratio）',
                '社内ネットワーク上で、ベンダー情報が不明なMACアドレスの割合です。不審な端末や非管理機器の接続が疑われるため、注意が必要です。'),
            _buildItem('検出デバイス数（device_count）',
                'LAN内で検出された端末の総数です。社内の想定台数より多い場合、私物機器や不正端末が接続されている可能性があります。'),
          ],
        ),
      ),
    );
  }
}

