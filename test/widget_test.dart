import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nwcd_c/main.dart';

void main() {
  testWidgets('HomePage scans and displays results', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('診断開始'), findsOneWidget);

    await tester.tap(find.text('診断開始'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.textContaining('危険なポート数'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });
}
