import 'package:flutter/material.dart';
import 'device_version_scan.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _realtimeLoading = false;
  bool _fullScanLoading = false;

  Future<void> _startRealTimeScan() async {
    setState(() => _realtimeLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _realtimeLoading = false);
  }

  Future<void> _startFullScan() async {
    setState(() => _fullScanLoading = true);
    final devices = await deviceVersionScan();
    if (!mounted) return;
    setState(() => _fullScanLoading = false);

    String formatDevices(Iterable<DeviceInfo> info) =>
        info.map((d) => '${d.ip} (${d.name})').join(', ');

    final osPending = formatDevices(devices.where((d) => d.osUpdatePending));
    final rdpOpen = formatDevices(devices.where((d) => d.rdpPortOpen));
    final cveVuln = formatDevices(devices.where((d) => d.cveVulnerable));

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('スキャン結果'),
        content: SingleChildScrollView(
          child: DataTable(
            columns: const [
              DataColumn(label: Text('スキャン項目')),
              DataColumn(label: Text('リスクのある端末一覧')),
            ],
            rows: [
              DataRow(cells: [
                const DataCell(Text('OSアップデート未適用')),
                DataCell(Text(osPending.isNotEmpty ? osPending : '-')),
              ]),
              DataRow(cells: [
                const DataCell(Text('RDPポート開放 (3389)')),
                DataCell(Text(rdpOpen.isNotEmpty ? rdpOpen : '-')),
              ]),
              DataRow(cells: [
                const DataCell(Text('CVE脆弱性検出あり')),
                DataCell(Text(cveVuln.isNotEmpty ? cveVuln : '-')),
              ]),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _realtimeLoading || _fullScanLoading;
    return Scaffold(
      appBar: AppBar(title: const Text('ホーム')),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: _startRealTimeScan,
                    child: const Text('リアルタイム'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _startFullScan,
                    child: const Text('フルスキャン'),
                  ),
                ],
              ),
      ),
    );
  }
}
