// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import '../models/product.dart';

class PriceLabel extends StatelessWidget {
  final double harga;

  const PriceLabel({super.key, required this.harga});

  @override
  Widget build(BuildContext context) {
    return Text(
      formatRupiah(harga),
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

class StockBadge extends StatelessWidget {
  final String status;

  const StockBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final warna = switch (status) {
      'Tersedia' => Colors.green,
      'Stok Terbatas' => Colors.orange,
      _ => Colors.red,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: warna.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: warna),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: warna,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class CategoryTag extends StatelessWidget {
  final String category;

  const CategoryTag({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        category,
        style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product produk;

  const ProductCard({super.key, required this.produk});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    print('initState -> ${widget.produk.name}');
  }

  @override
  void dispose() {
    print('dispose -> ${widget.produk.name}');
    super.dispose();
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build -> ${widget.produk.name}, isFavorite: $isFavorite');
    final produk = widget.produk;
    final diskon = diskonKategori(produk.category);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.image_outlined, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  CategoryTag(category: produk.category),
                  Text(
                    produk.description ?? 'Belum ada deskripsi',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  StockBadge(status: produk.getStatusStok()),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                PriceLabel(harga: produk.price),
                Text('Stok ${produk.stock}'),
                if (diskon > 0) Text('Diskon ${diskon.toStringAsFixed(0)}%'),
                IconButton(
                  onPressed: _toggleFavorite,
                  tooltip: 'Tandai favorit',
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
