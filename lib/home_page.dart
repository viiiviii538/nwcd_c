import 'package:flutter/material.dart';
import 'port_scan.dart';

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
    final results = await portScan();
    if (!mounted) return;
    setState(() => _fullScanLoading = false);
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ポート開放チェック結果'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final result in results) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ポート：${result.port}'),
                      Text('リスク：${result.risk}'),
                    ],
                  ),
                ),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('IPアドレス')),
                    DataColumn(label: Text('ホスト名')),
                    DataColumn(label: Text('コメント')),
                  ],
                  rows: [
                    for (final entry in result.entries)
                      DataRow(cells: [
                        DataCell(Text(entry.ipAddress)),
                        DataCell(Text(entry.hostName)),
                        DataCell(Text(entry.comment)),
                      ]),
                  ],
                ),
                const SizedBox(height: 16),
              ],
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
