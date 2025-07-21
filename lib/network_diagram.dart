import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'network_scanner.dart';

/// Displays a simple star topology graph of the discovered [devices].
class NetworkDiagram extends StatelessWidget {
  final List<NetworkDevice> devices;

  const NetworkDiagram({super.key, required this.devices});

  @override
  Widget build(BuildContext context) {
    final graph = Graph()..isTree = true;
    final root = Node.Id('Local');
    graph.addNode(root);
    for (final d in devices) {
      final label = d.name.isNotEmpty ? d.name : d.ip;
      final node = Node.Id(label);
      graph.addNode(node);
      graph.addEdge(root, node);
    }

    final layout = BuchheimWalkerConfiguration()
      ..siblingSeparation = 20
      ..levelSeparation = 30
      ..subtreeSeparation = 30
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(20),
      minScale: 0.01,
      maxScale: 5,
      child: GraphView(
        graph: graph,
        algorithm: BuchheimWalkerAlgorithm(layout, TreeEdgeRenderer(layout)),
        builder: (Node node) {
          final id = node.key?.value ?? '';
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('$id'),
            ),
          );
        },
      ),
    );
  }
}
