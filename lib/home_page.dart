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
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('スキャン結果'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final device in devices)
                ListTile(
                  title: Text(device.name),
                  subtitle: Text(
                    'OS: ${device.osVersion}\n'
                    'FW: ${device.firmwareVersion}\n'
                    'SW: ${device.softwareVersion}',
                  ),
                  trailing: Text(
                    device.vulnerable ? '脆弱性あり' : '安全',
                    style: TextStyle(
                      color: device.vulnerable ? Colors.red : Colors.black,
                    ),
                  ),
                ),
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
