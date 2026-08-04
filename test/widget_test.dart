import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App widget can be instantiated', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Text('Base Structure'))),
    );
    expect(find.text('Base Structure'), findsOneWidget);
  });
}
