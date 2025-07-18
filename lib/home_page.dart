import 'package:flutter/material.dart';

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
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _fullScanLoading = false);
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
