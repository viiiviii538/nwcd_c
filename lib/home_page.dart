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
  String? _deviceInfo;
  String? _portInfo;
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
    final device = await scanDeviceVersion();
    final ports = await checkOpenPorts();
    if (!mounted) return;
    setState(() {
      _fullScanLoading = false;
      _deviceInfo = device;
      _portInfo = ports;
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
