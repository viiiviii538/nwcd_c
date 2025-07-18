import 'package:flutter/material.dart';

class PortInfo {
  const PortInfo(this.port, this.open);

  final int port;
  final bool open;
}

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key, required this.results});

  final List<PortInfo> results;

  static const dangerousPorts = {21, 23, 25, 445};

  int get dangerousOpenCount =>
      results.where((p) => p.open && dangerousPorts.contains(p.port)).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Results')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final content = Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  color: Colors.red.shade100,
                  child: ListTile(
                    title: const Text('Dangerous Ports'),
                    subtitle: Text('$dangerousOpenCount open'),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final port = results[index];
                      return Card(
                        child: ListTile(
                          title: Text('Port ${port.port}'),
                          trailing: Text(
                            port.open ? 'Open' : 'Closed',
                            style: TextStyle(
                              color:
                                  port.open ? Colors.red : Colors.green,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
          if (constraints.maxWidth > 600) {
            return Center(
              child: SizedBox(width: 600, child: content),
            );
          }
          return content;
        },
      ),
    );
  }
}
