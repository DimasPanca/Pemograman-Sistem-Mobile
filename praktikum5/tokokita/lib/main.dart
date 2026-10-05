import 'package:flutter/material.dart';

import 'models/product.dart';
import 'screens/main_page.dart';
import 'screens/product_detail_page.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final produk = settings.arguments as Product;
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => ProductDetailPage(produk: produk),
          );
        }
        return null;
      },
    );
  }
}
