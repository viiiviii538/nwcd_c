import 'package:flutter/material.dart';

class FullScanResultPage extends StatefulWidget {
  final String fullScanResult;
  final List<String> realTimeLogs;

  const FullScanResultPage({
    super.key,
    required this.fullScanResult,
    required this.realTimeLogs,
  });

  @override
  State<FullScanResultPage> createState() => _FullScanResultPageState();
}

class _FullScanResultPageState extends State<FullScanResultPage> {
  String? _summary;

  void _aggregate() {
    final realtime = widget.realTimeLogs.join('\n');
    _summary = 'リアルタイム:\n$realtime\n\nフルスキャン:\n${widget.fullScanResult}';
    setState(() {});
    // ignore: avoid_print
    print(_summary);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('フルスキャン結果')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.fullScanResult),
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
      ),
    );
  }
}
