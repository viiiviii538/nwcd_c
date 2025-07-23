import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'network_scanner.dart';
import 'topology_scanner.dart';

/// Displays a simple star topology graph of the discovered [devices].
class NetworkDiagram extends StatelessWidget {
  /// Devices displayed in the diagram.
  final List<NetworkDevice> devices;

  /// Optional topology describing how devices are connected. If empty,
  /// a star topology anchored at "Local" is used.
  final List<TopologyLink> topology;

  /// Optional width for the diagram. Specify when a fixed size is required.
  final double? width;

  /// Optional height for the diagram. Specify when a fixed size is required.
  final double? height;

  const NetworkDiagram({
    super.key,
    required this.devices,
    this.topology = const [],
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final graph = Graph();
    final nodes = <String, Node>{};

    Node getNode(String id) {
      return nodes.putIfAbsent(id, () => Node.Id(id));
    }

    if (topology.isEmpty) {
      final root = getNode('Local');
      for (final d in devices) {
        final label = d.name.isNotEmpty ? d.name : d.ip;
        graph.addEdge(root, getNode(label));
      }
    } else {
      for (final link in topology) {
        graph.addEdge(getNode(link.from), getNode(link.to));
      }
    }

    final layout = BuchheimWalkerConfiguration()
      ..siblingSeparation = 20
      ..levelSeparation = 30
      ..subtreeSeparation = 30
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

    Widget graphWidget = GraphView(
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
    );

    if (width != null || height != null) {
      graphWidget = SizedBox(width: width, height: height, child: graphWidget);
    }

    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(20),
      minScale: 0.01,
      maxScale: 5,
      child: graphWidget,
    );
  }
}
