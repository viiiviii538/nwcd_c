import 'package:flutter/material.dart';
import 'scan_result_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _scanning = false;

  Future<void> _startScan() async {
    setState(() {
      _scanning = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _scanning = false;
    });
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ScanResultPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホームタブ'),
      ),
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
