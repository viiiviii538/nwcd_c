import 'package:flutter/material.dart';
import 'home_page.dart';
import 'network_scanner.dart';
import 'topology_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final Future<List<NetworkDevice>> Function()? networkScanFn;
  final Future<List<TopologyLink>> Function()? topologyScanFn;

  const MyApp({super.key, this.networkScanFn, this.topologyScanFn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Security Scan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(
        scanNetworkFn: networkScanFn,
        scanTopologyFn: topologyScanFn,
      ),
    );
  }
}
