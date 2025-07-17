import 'package:flutter/material.dart';
import 'scan_result_page.dart';
import 'scan_service.dart';
import 'models/scan_result.dart';
import 'pages/dummy_tab_page.dart';

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
    try {
      final ScanService service = ScanService();
      final ScanResult result = await service.runScan();
      if (!mounted) return;
      setState(() {
        _scanning = false;
      });
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ScanResultPage(result: result)),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _scanning = false;
      });
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ホーム'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '診断'),
              Tab(text: 'ダミータブ'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: _scanning
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _startScan,
                      child: const Text('診断開始'),
                    ),
            ),
            const DummyTabPage(),
          ],
        ),
      ),
    );
  }
}
