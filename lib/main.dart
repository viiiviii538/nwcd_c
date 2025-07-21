import 'package:flutter/material.dart';
import 'home_page.dart';
import 'network_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final Future<List<NetworkDevice>> Function()? networkScanFn;

  const MyApp({super.key, this.networkScanFn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Security Scan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(scanNetworkFn: networkScanFn),
    );
  }
}
