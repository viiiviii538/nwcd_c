import 'package:flutter/material.dart';
import 'dart:async';
import 'full_scan_result_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _realtimeRunning = false;
  bool _fullScanLoading = false;
  final List<String> _realtimeLogs = [];
  String? _fullScanResult;
  Timer? _realtimeTimer;

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
    setState(() => _fullScanLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    _fullScanResult = 'Full scan finished at ${DateTime.now()}';
    setState(() => _fullScanLoading = false);
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScanResultPage(
          fullScanResult: _fullScanResult!,
          realTimeLogs: _realtimeLogs,
        ),
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
              Tab(text: 'リアルタイム'),
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

  Widget _buildRealtimeTab() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: _realtimeRunning ? _stopRealTimeScan : _startRealTimeScan,
            child: Text(_realtimeRunning ? 'リアルタイム停止' : 'リアルタイム開始'),
          ),
          const SizedBox(height: 16),
          if (_realtimeRunning) const CircularProgressIndicator(),
          if (_realtimeLogs.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(_realtimeLogs.last),
          ],
        ],
      ),
    );
  }

  Widget _buildFullScanTab() {
    final isLoading = _fullScanLoading;
    return Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: _startFullScan,
                  child: const Text('フルスキャン開始'),
                ),
                const SizedBox(height: 16),
                if (_fullScanResult != null) Text(_fullScanResult!),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _realtimeTimer?.cancel();
    super.dispose();
  }
}
