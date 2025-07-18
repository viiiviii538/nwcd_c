import 'package:flutter/material.dart';
import 'results_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _scanning = false;

  Future<void> _startScan() async {
    setState(() => _scanning = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _scanning = false);

    final results = [
      const PortInfo(21, true),
      const PortInfo(22, false),
      const PortInfo(23, true),
      const PortInfo(80, true),
      const PortInfo(443, true),
      const PortInfo(445, false),
    ];

    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ResultsPage(results: results),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ホーム')),
      body: Center(
        child: _scanning
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _startScan,
                child: const Text('診断開始'),
              ),
      ),
    );
  }
}
