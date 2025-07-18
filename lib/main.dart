import 'package:flutter/material.dart';
import 'home_page.dart';
import 'port_scanner.dart';

void main() {
  runApp(MyApp(scanner: const PortScanner()));
}

class MyApp extends StatelessWidget {
  final PortScanner scanner;

  const MyApp({super.key, required this.scanner});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Security Scan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(scanner: scanner),
    );
  }
}
