import 'package:flutter/material.dart';

import 'models/product.dart';
import 'widgets/product_card.dart';

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
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blue)),
      home: const ProductPage(),
    );
  }
}

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('TokoKita - Daftar Produk'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Daftar Produk',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          const Text('Data contoh untuk dasar aplikasi toko online.'),
          const SizedBox(height: 8),
          const Wrap(
            spacing: 6,
            children: [
              CategoryTag(category: 'Elektronik'),
              CategoryTag(category: 'Fashion'),
              CategoryTag(category: 'Makanan'),
            ],
          ),
          const SizedBox(height: 8),
          ...daftarProduk.map((produk) => ProductCard(produk: produk)),
        ],
      ),
    );
  }
}
