import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';
import 'product_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductService _service = ProductService();
  late Future<List<Product>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchProducts();
  }

  Future<void> _reload() async {
    final baru = _service.fetchProducts();
    try {
      await baru;
    } catch (_) {
      // error ditampilkan lewat FutureBuilder setelah future diganti
    }
    if (!mounted) return;
    setState(() {
      _future = baru;
    });
  }

  void _cobaLagi() {
    setState(() {
      _future = _service.fetchProducts();
    });
  }

  void _bukaDetail(Product produk) {
    Get.to(() => ProductDetailPage(produk: produk));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _AppHeader(),
            const _Sapaan(),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const _Loading();
                  }
                  if (snapshot.hasError) {
                    return _ErrorView(
                      pesan: snapshot.error.toString(),
                      onCobaLagi: _cobaLagi,
                    );
                  }
                  final produk = snapshot.data ?? const <Product>[];
                  if (produk.isEmpty) {
                    return const Center(child: Text('Belum ada produk'));
                  }
                  return RefreshIndicator(
                    onRefresh: _reload,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: produk.length,
                      itemBuilder: (context, index) {
                        final p = produk[index];
                        return InkWell(
                          onTap: () => _bukaDetail(p),
                          child: ProductCard(produk: p),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text('Memuat produk dari server...',
              style: TextStyle(fontSize: 13, color: Colors.black54)),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String pesan;
  final VoidCallback onCobaLagi;

  const _ErrorView({required this.pesan, required this.onCobaLagi});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.cloud_off,
                  size: 48, color: Colors.red.shade400),
            ),
            const SizedBox(height: 14),
            const Text(
              'Gagal memuat produk, coba lagi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              pesan,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: onCobaLagi,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppHeader extends StatelessWidget {
  const _AppHeader();

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.storefront,
                    color: Colors.blue, size: 22),
              ),
              const SizedBox(width: 10),
              const Text(
                'TokoKita',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {},
                tooltip: 'Keranjang',
              ),
              Positioned(
                right: 4,
                top: 4,
                child: Obx(() {
                  final jumlah = cart.totalItem;
                  if (jumlah == 0) return const SizedBox.shrink();
                  return Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    constraints:
                        const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      jumlah.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Sapaan extends StatelessWidget {
  const _Sapaan();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Halo, Dimas',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 2),
          Text(
            'Belanja jadi lebih mudah bareng TokoKita',
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
