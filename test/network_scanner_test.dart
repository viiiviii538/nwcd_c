import 'package:flutter_test/flutter_test.dart';
import 'package:nwcd_c/network_scanner.dart';

void main() {
  test('maskToPrefix converts dotted mask to prefix', () {
    expect(maskToPrefix('255.255.255.0'), 24);
    expect(maskToPrefix('255.255.0.0'), 16);
  });

  test('calculateNetwork computes correct network address', () {
    expect(calculateNetwork('192.168.1.5', 24), '192.168.1.0');
    expect(calculateNetwork('10.0.1.50', 16), '10.0.0.0');
  });

  test('pingSweepForTest limits large networks', () async {
    final pinged = <String>[];
    await pingSweepForTest(
      '192.168.0.0/16',
      pingAddress: (ip) async => pinged.add(ip),
      readArpTable: () async => <NetworkDevice>[],
      maxHosts: 10,
    );
    expect(pinged.length, 10);
    expect(pinged.first, '192.168.0.1');
    expect(pinged.last, '192.168.0.10');
  });

  test('pingSweepForTest scans full range when small', () async {
    final pinged = <String>[];
    await pingSweepForTest(
      '10.0.0.0/30',
      pingAddress: (ip) async => pinged.add(ip),
      readArpTable: () async => <NetworkDevice>[],
    );
    expect(pinged, ['10.0.0.1', '10.0.0.2']);
  });
}
