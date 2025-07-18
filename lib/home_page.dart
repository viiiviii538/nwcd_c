import 'package:flutter/material.dart';

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
                  const SizedBox(height: 16),
                  const Text(
                    'Scan only networks you are authorized to test.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
      ),
    );
  }
}
