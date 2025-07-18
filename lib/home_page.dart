import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = false;

  Future<void> _startScan() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ホーム')),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : ElevatedButton(
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