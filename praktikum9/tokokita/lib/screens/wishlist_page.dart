import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/wishlist_controller.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final WishlistController wishlist = Get.find<WishlistController>();
  final ProductService _service = ProductService();
  late final Future<List<Product>> _semuaProduk;

  @override
  void initState() {
    super.initState();
    _semuaProduk = _service.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      appBar: AppBar(
        title: const Text('Produk Favorit'),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: _semuaProduk,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Gagal memuat data produk'));
          }
          final semua = snapshot.data ?? const <Product>[];
          return Obx(() {
            final favorit =
                semua.where((p) => wishlist.isFavorite(p.id)).toList();
            if (favorit.isEmpty) return const _Kosong();
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favorit.length,
              itemBuilder: (context, i) => _BarisFavorit(
                produk: favorit[i],
                onHapus: () => wishlist.toggle(favorit[i].id),
              ),
            );
          });
        },
      ),
    );
  }
}

class _Kosong extends StatelessWidget {
  const _Kosong();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border, size: 60, color: Colors.red.shade200),
            const SizedBox(height: 12),
            const Text('Belum ada produk favorit',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text(
              'Tekan ikon hati pada produk di beranda untuk menyimpannya.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarisFavorit extends StatelessWidget {
  final Product produk;
  final VoidCallback onHapus;

  const _BarisFavorit({required this.produk, required this.onHapus});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAlias,
            child: produk.imageUrl.isEmpty
                ? const Icon(Icons.image_outlined, color: Colors.blueGrey)
                : Image.network(produk.imageUrl, fit: BoxFit.contain),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(produk.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(formatRupiah(produk.price),
                    style: const TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Hapus dari favorit',
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: onHapus,
          ),
        ],
      ),
    );
  }
}
