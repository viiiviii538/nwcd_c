import 'package:flutter/material.dart';
import 'full_scan_result_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _realtimeLoading = false;
  bool _fullScanLoading = false;
  final List<String> _realtimeLogs = [];
  String? _fullScanResult;

  Future<void> _startRealTimeScan() async {
    setState(() => _realtimeLoading = true);
    _realtimeLogs.add('Started at ${DateTime.now()}');
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    _realtimeLogs.add('Finished at ${DateTime.now()}');
    setState(() => _realtimeLoading = false);
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
      child: _realtimeLoading
          ? const CircularProgressIndicator()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: _startRealTimeScan,
                  child: const Text('リアルタイム開始'),
                ),
                const SizedBox(height: 16),
                if (_realtimeLogs.isNotEmpty)
                  Text(_realtimeLogs.last),
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
}
