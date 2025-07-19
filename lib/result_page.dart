import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final String deviceInfo;
  final String portInfo;

  const ResultPage({
    super.key,
    required this.deviceInfo,
    required this.portInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('診断結果')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('デバイス情報', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(deviceInfo),
            const SizedBox(height: 16),
            Text('ポート開放状況', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(portInfo),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('完了'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
