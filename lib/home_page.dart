import 'dart:async';
import 'package:flutter/material.dart';
import 'scanner.dart';
import 'network_scanner.dart';

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
  String? _deviceInfo;
  String? _portInfo;
  bool _networkScanLoading = false;
  List<NetworkDevice>? _networkDevices;
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
      _deviceInfo = null;
      _portInfo = null;
    });
    final info = await deviceVersionScan('127.0.0.1');
    final device = info.toString();
    final ports = await checkOpenPorts();
    if (!mounted) return;
    setState(() {
      _fullScanLoading = false;
      _deviceInfo = device;
      _portInfo = ports;
    });
  }

  Future<void> _startNetworkScan() async {
    setState(() {
      _networkScanLoading = true;
      _networkDevices = null;
    });
    final devices = await scanNetwork();
    if (!mounted) return;
    setState(() {
      _networkScanLoading = false;
      _networkDevices = devices;
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
            Text(_deviceInfo!),
            const SizedBox(height: 16),
            Text('ポート開放状況',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(_portInfo!),
          ],
        ],
      ),
    );
  }

  Widget _buildNetworkDiagramTab() {
    final devices = _networkDevices;
    final isLoading = _networkScanLoading;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: isLoading ? null : _startNetworkScan,
            child: const Text('ネットワークスキャン開始'),
          ),
          const SizedBox(height: 16),
          if (isLoading) const CircularProgressIndicator(),
          if (!isLoading && devices != null)
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('IPアドレス')),
                    DataColumn(label: Text('MACアドレス')),
                    DataColumn(label: Text('ベンダー名')),
                    DataColumn(label: Text('機器名')),
                  ],
                  rows: devices
                      .map(
                        (d) => DataRow(cells: [
                          DataCell(Text(d.ip)),
                          DataCell(Text(d.mac)),
                          DataCell(Text(d.vendor)),
                          DataCell(Text(d.name)),
                        ]),
                      )
                      .toList(),
                ),
              ),
            ),
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
