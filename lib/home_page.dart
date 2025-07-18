import 'package:flutter/material.dart';
import 'port_scanner.dart';

class HomePage extends StatefulWidget {
  final PortScanner scanner;

  const HomePage({super.key, required this.scanner});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _scanning = false;
  List<PortScanResult>? _results;

  Future<void> _startScan() async {
    setState(() {
      _scanning = true;
      _results = null;
    });

    final ports = [21, 22, 80, 443, 445, 3389];
    final scanMap = await widget.scanner.scanPorts('127.0.0.1', ports);
    final results = mapToScanResults(scanMap);

    if (!mounted) return;
    setState(() {
      _scanning = false;
      _results = results;
    });
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
                ? Center(
                    child: ElevatedButton(
                      onPressed: _startScan,
                      child: const Text('診断開始'),
                    ),
                  )
                : _buildResults(),
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
      ],
    );
  }
}
