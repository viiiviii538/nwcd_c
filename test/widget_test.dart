import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nwcd_c/main.dart';

void main() {
  testWidgets('HomePage shows scan button', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('診断開始'), findsOneWidget);

    await tester.tap(find.text('診断開始'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
