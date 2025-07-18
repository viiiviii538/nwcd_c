import 'package:flutter/material.dart';
import 'dart:async';
import 'port_scanner.dart';

class HomePage extends StatefulWidget {
  final PortScanner scanner;

  const HomePage({super.key, required this.scanner});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _scanning = false;
  bool _continuousScanning = false;
  Timer? _scanTimer;
  List<PortScanResult>? _results;

  Future<void> _startScan() async {
    setState(() {
      _scanning = true;
      _results = null;
    });

    final ports = [21, 22, 80, 443, 445, 3389];
    final portMap = await widget.scanner.scanPorts('127.0.0.1', ports);
    final results = <PortScanResult>[];
    for (final entry in portMap.entries) {
      if (entry.value) {
        results.add(
          PortScanResult(entry.key, dangerous: dangerousPorts.contains(entry.key)),
        );
      }
    }

    if (!mounted) return;
    setState(() {
      _scanning = false;
      _results = results;
    });
  }

  void _startContinuousScan() {
    if (_continuousScanning) return;
    setState(() {
      _continuousScanning = true;
    });
    _scanTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      final ports = [21, 22, 80, 443, 445, 3389];
      await widget.scanner.scanPorts('127.0.0.1', ports);
      if (!mounted) return;
      setState(() {});
    });
  }

  void _stopContinuousScan() {
    _scanTimer?.cancel();
    _scanTimer = null;
    setState(() {
      _continuousScanning = false;
    });
  }

  @override
  void dispose() {
    _scanTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ホーム')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _scanning
            ? const Center(child: CircularProgressIndicator())
            : _results == null
                ? _buildInitialButtons()
                : _buildResults(),
      ),
    );
  }

  Widget _buildInitialButtons() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: _startScan,
            child: const Text('診断開始'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed:
                _continuousScanning ? _stopContinuousScan : _startContinuousScan,
            child: Text(
                _continuousScanning ? 'Stop Continuous Scan' : 'Continuous Scan'),
          ),
          if (_continuousScanning) ...[
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
        ],
      ),
    );
  }

  Widget _buildResults() {
    final dangerousCount =
        _results!.where((r) => r.dangerous).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('危険なポート数: $dangerousCount'),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: _results!.length,
            itemBuilder: (context, index) {
              final result = _results![index];
              return ListTile(
                title: Text('Port ${result.port}'),
                trailing: result.dangerous
                    ? const Text(
                        'Danger',
                        style: TextStyle(color: Colors.red),
                      )
                    : null,
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: _startScan,
            child: const Text('再診断'),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed:
                _continuousScanning ? _stopContinuousScan : _startContinuousScan,
            child: Text(
                _continuousScanning ? 'Stop Continuous Scan' : 'Continuous Scan'),
          ),
        ),
        if (_continuousScanning) ...[
          const SizedBox(height: 16),
          const Center(child: CircularProgressIndicator()),
        ],
      ],
    );
  }
}
