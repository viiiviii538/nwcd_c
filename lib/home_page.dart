import 'package:flutter/material.dart';
import 'dart:async';

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
  final List<String> _realtimeLogs = [];
  String? _fullScanResult;
  String? _summary;
  Timer? _realtimeTimer;

  void _aggregate() {
    final realtime = _realtimeLogs.join("\n");
    _summary = "リアルタイム:\n" + realtime + "\n\nフルスキャン:\n" + _fullScanResult.toString();
    setState(() {});
    print(_summary);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
    _tabController.animateTo(1);
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
    _tabController.animateTo(3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'リアルタイム'),
            Tab(text: 'リアルタイム出力'),
            Tab(text: 'フルスキャン'),
            Tab(text: 'フルスキャン結果'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRealtimeTab(),
          _buildRealtimeOutputTab(),
          _buildFullScanTab(),
          _buildFullScanResultTab(),
        ],
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
        ],
      ),
    );
  }

  Widget _buildRealtimeOutputTab() {
    return ListView.builder(
      itemCount: _realtimeLogs.length,
      itemBuilder: (_, index) => ListTile(title: Text(_realtimeLogs[index])),
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
              ],
            ),
    );
  }

  Widget _buildFullScanResultTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_fullScanResult != null) Text(_fullScanResult!),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _aggregate,
            child: const Text('完了'),
          ),
          const SizedBox(height: 16),
          if (_summary != null)
            Expanded(
              child: SingleChildScrollView(
                child: Text(_summary!),
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
