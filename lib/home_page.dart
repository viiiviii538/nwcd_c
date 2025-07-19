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
  List<DeviceInfo>? _scanResults;

  Future<void> _startRealTimeScan() async {
    setState(() => _realtimeLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _realtimeLoading = false);
  }

  Future<void> _startFullScan() async {
    setState(() {
      _fullScanLoading = true;
      _scanResults = null;
    });
    final devices = await deviceVersionScan();
    if (!mounted) return;
    setState(() {
      _fullScanLoading = false;
      _scanResults = devices;
    });
  }

  Widget _buildRealtimeTab() {
    if (_realtimeLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Center(
      child: ElevatedButton(
        onPressed: _startRealTimeScan,
        child: const Text('リアルタイム診断開始'),
      ),
    );
  }

  Widget _buildFullScanTab() {
    if (_fullScanLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_scanResults == null) {
      return Center(
        child: ElevatedButton(
          onPressed: _startFullScan,
          child: const Text('フルスキャン開始'),
        ),
      );
    }

    String formatDevices(Iterable<DeviceInfo> info) =>
        info.map((d) => '${d.ip} (${d.name})').join(', ');

    final osPending = formatDevices(
      _scanResults!.where((d) => d.osUpdatePending),
    );
    final rdpOpen =
        formatDevices(_scanResults!.where((d) => d.rdpPortOpen));
    final cveVuln =
        formatDevices(_scanResults!.where((d) => d.cveVulnerable));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          DataTable(
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
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _startFullScan,
            child: const Text('再スキャン'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ホーム'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'リアルタイム診断'),
              Tab(text: 'フルスキャン'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRealtimeTab(),
            _buildFullScanTab(),
          ],
        ),
      ),
    );
  }
}
