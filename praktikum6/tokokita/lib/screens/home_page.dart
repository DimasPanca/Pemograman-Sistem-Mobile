import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'product_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: daftarProduk.length,
                itemBuilder: (context, index) {
                  final produk = daftarProduk[index];
                  return InkWell(
                    onTap: () => _bukaDetail(produk),
                    child: ProductCard(produk: produk),
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
                style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
