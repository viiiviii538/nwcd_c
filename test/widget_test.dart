// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nwcd_c/main.dart';

void main() {
  testWidgets('Home and dummy tabs are present', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('ホームタブ'), findsOneWidget);
    expect(find.text('ダミータブ'), findsOneWidget);

    // Home tab is selected by default, so the scan button should be visible.
    expect(find.text('診断開始'), findsOneWidget);
  });
}
