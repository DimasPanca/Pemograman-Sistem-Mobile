import 'package:flutter/material.dart';

import 'models/product.dart';
import 'screens/home_page.dart';

void main() {
  demoProductLogic();
  // ignore: avoid_print
  print('Aplikasi TokoKita dimulai dari main()');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TokoKita',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      home: const HomePage(),
    );
  }
}
