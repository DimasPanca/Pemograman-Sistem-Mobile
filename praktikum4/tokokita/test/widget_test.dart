import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:tokokita/main.dart';

void main() {
  testWidgets('TokoKita menampilkan data produk', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('TokoKita'), findsOneWidget);
    expect(find.text('Daftar Produk'), findsOneWidget);
    expect(find.text('Smartphone Entry'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -2000));
    await tester.pumpAndSettle();
    expect(find.text('Powerbank 10000mAh'), findsOneWidget);
  });
}
