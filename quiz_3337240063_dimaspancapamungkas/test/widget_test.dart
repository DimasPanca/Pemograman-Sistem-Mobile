import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quiz_3337240063_dimaspancapamungkas/main.dart';

void main() {
  testWidgets('Login screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const PaperlogApp());
    expect(find.text('Masuk sekarang'), findsOneWidget);
  });
}
