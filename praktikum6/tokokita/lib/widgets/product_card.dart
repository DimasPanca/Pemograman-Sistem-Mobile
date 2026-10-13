// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import '../models/product.dart';

class PriceLabel extends StatelessWidget {
  final double harga;
  final double? hargaAsli;

  const PriceLabel({super.key, required this.harga, this.hargaAsli});

  @override
  Widget build(BuildContext context) {
    if (hargaAsli != null && hargaAsli! > harga) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            formatRupiah(hargaAsli!),
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          Text(
            formatRupiah(harga),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
        ],
      );
    }
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
          fontSize: 11,
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
        style: const TextStyle(fontSize: 11, color: Colors.blueGrey),
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
    final diskonProduk = produk is DiscountedProduct ? produk : null;
    final statusStok = produk.getStatusStok();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGambarDenganBadge(diskonProduk, statusStok),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produk.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                CategoryTag(category: produk.category),
                Text(
                  produk.description ?? 'Belum ada deskripsi',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 6),
                Text('Stok ${produk.stock}',
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              PriceLabel(
                harga: diskonProduk?.getHargaFinal() ?? produk.price,
                hargaAsli: diskonProduk?.price,
              ),
              IconButton(
                onPressed: _toggleFavorite,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'Tandai favorit',
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGambarDenganBadge(
      DiscountedProduct? diskonProduk, String statusStok) {
    return SizedBox(
      width: 82,
      height: 90,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.image_outlined,
                size: 34, color: Colors.blueGrey),
          ),
          if (diskonProduk != null)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Diskon ${diskonProduk.discountPercent.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: -2,
            left: 0,
            right: 0,
            child: Center(child: StockBadge(status: statusStok)),
          ),
        ],
      ),
    );
  }
}
