import 'dart:async';
import 'package:flutter/material.dart';
import 'scanner.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _realtimeRunning = false;
  bool _fullScanLoading = false;
  List<DeviceInfo>? _deviceInfo;
  String? _portInfo;
  List<DeviceInfo>? _scanResults;
  final List<String> _realtimeLogs = [];
  Timer? _realtimeTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _startRealTimeScan() {
    if (_realtimeRunning) return;
    setState(() {
      _realtimeRunning = true;
      _realtimeLogs.add('Started at ${DateTime.now()}');
    });
    _realtimeTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _realtimeLogs.add('Tick at ${DateTime.now()}');
      });
    });
  }

  void _stopRealTimeScan() {
    _realtimeTimer?.cancel();
    _realtimeTimer = null;
    if (mounted) {
      setState(() {
        _realtimeRunning = false;
        _realtimeLogs.add('Stopped at ${DateTime.now()}');
      });
    }
  }

  Future<void> _startFullScan() async {
    setState(() {
      _fullScanLoading = true;
      _scanResults = null;
    });
    final device = await deviceVersionScan();
    final ports = await checkOpenPorts();
    final results = await deviceVersionScan();
    if (!mounted) return;
    setState(() {
      _fullScanLoading = false;
      _scanResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'リアルタイム診断'),
            Tab(text: 'フルスキャン'),
            Tab(text: 'ネットワーク図'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRealtimeTab(),
          _buildFullScanTab(),
          _buildNetworkDiagramTab(),
        ],
      ),
    );
  }

  Widget _buildRealtimeTab() {
    return Column(
      children: [
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _realtimeRunning ? _stopRealTimeScan : _startRealTimeScan,
          child: Text(_realtimeRunning ? 'リアルタイム停止' : 'リアルタイム開始'),
        ),
        const SizedBox(height: 16),
        if (_realtimeRunning) const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: _realtimeLogs.length,
            itemBuilder: (_, index) => ListTile(title: Text(_realtimeLogs[index])),
          ),
        ),
      ],
    );
  }

  Widget _buildFullScanTab() {
    final isLoading = _fullScanLoading;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: isLoading ? null : _startFullScan,
            child: const Text('フルスキャン開始'),
          ),
          const SizedBox(height: 16),
          if (isLoading) const CircularProgressIndicator(),
          if (!isLoading && _deviceInfo != null && _portInfo != null) ...[
            Text('デバイス情報',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            DataTable(
              columns: const [
                DataColumn(label: Text('名前')),
                DataColumn(label: Text('バージョン')),
              ],
              rows: _deviceInfo!
                  .map((d) => DataRow(cells: [
                        DataCell(Text(d.name)),
                        DataCell(Text(d.version)),
                      ]))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Text('ポート開放状況',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(_portInfo!),
          ],
          if (!isLoading && _scanResults != null)
            Expanded(
              child: ListView(
                children: [
                  _buildResultRow(
                    'OSアップデート未適用',
                    _scanResults!
                        .where((d) => d.osUpdatePending)
                        .map((d) => d.name)
                        .toList(),
                  ),
                  _buildResultRow(
                    'RDPポート開放 (3389)',
                    _scanResults!
                        .where((d) => d.rdpOpen)
                        .map((d) => d.name)
                        .toList(),
                  ),
                  _buildResultRow(
                    'CVE脆弱性検出あり',
                    _scanResults!
                        .where((d) => d.hasCve)
                        .map((d) => d.name)
                        .toList(),
                  ),
                ],
              ),
            ),
        ],
      ),
      );
  }

  Widget _buildResultRow(String title, List<String> devices) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          ...devices.map(Text.new),
          if (devices.isEmpty) const Text('-'),
        ],
      ),
    );
  }

  Widget _buildNetworkDiagramTab() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.network_check, size: 96),
          SizedBox(height: 16),
          Text('ネットワーク図がここに表示されます'),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _realtimeTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }
}
