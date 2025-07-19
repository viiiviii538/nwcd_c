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
}
