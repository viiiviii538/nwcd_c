import 'package:flutter_test/flutter_test.dart';
import 'package:nwcd_c/topology_scanner.dart';

void main() {
  test('parseLldpctlForTest parses neighbors', () {
    const sample = '''
Interface:    enp0s3, via: LLDP, RID: 1, Time: 0 day, 00:32:08
  Chassis:
    SysName: switch01

Interface:    eth0, via: LLDP, RID: 2, Time: 0 day, 00:32:08
  Chassis:
    SysName: router01
''';
    final links = parseLldpctlForTest(sample);
    expect(links.length, 2);
    expect(links[0].from, 'enp0s3');
    expect(links[0].to, 'switch01');
    expect(links[1].from, 'eth0');
    expect(links[1].to, 'router01');
  });
}
