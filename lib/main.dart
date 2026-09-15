import 'package:flutter/material.dart';

import 'models/product.dart';

void main() {
  demoProductLogic();
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
        title: const Text('TokoKita'),
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
          const SizedBox(height: 12),
          ...daftarProduk.map((produk) => ProductCard(produk: produk)),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product produk;

  const ProductCard({super.key, required this.produk});

  @override
  Widget build(BuildContext context) {
    final diskon = diskonKategori(produk.category);
    final warnaStatus = switch (produk.getStatusStok()) {
      'Tersedia' => Colors.green,
      'Stok Terbatas' => Colors.orange,
      _ => Colors.red,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(child: Text(produk.name.substring(0, 1))),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(produk.category),
                  Text(
                    produk.description ?? 'Belum ada deskripsi',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    produk.getStatusStok(),
                    style: TextStyle(color: warnaStatus),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatRupiah(produk.price),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Stok ${produk.stock}'),
                if (diskon > 0) Text('Diskon ${diskon.toStringAsFixed(0)}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
