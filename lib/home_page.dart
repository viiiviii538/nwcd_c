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
  Map<int, bool>? _results;

  Future<void> _startScan() async {
    setState(() {
      _scanning = true;
      _results = null;
    });
    final res = await widget.scanner.scanPorts('localhost', [80]);
    if (!mounted) return;
    setState(() {
      _scanning = false;
      _results = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ホーム')),
      body: Center(
        child: _scanning
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: _startScan,
                    child: const Text('診断開始'),
                  ),
                  if (_results != null)
                    ..._results!.entries
                        .map((e) => Text('Port ${e.key}: '
                            '${e.value ? 'open' : 'closed'}'))
                        .toList(),
                ],
              ),
      ),
    );
  }
}
