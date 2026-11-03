import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../controllers/auth_controller.dart';
import '../services/order_service.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import 'checkout_page.dart';

class KeranjangPage extends StatelessWidget {
  const KeranjangPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
        actions: [
          Obx(() {
            if (cart.items.isEmpty) return const SizedBox.shrink();
            return IconButton(
              tooltip: 'Kosongkan keranjang',
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: () => _konfirmasiKosongkan(cart),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (cart.items.isEmpty) return const _KeranjangKosong();
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return _ItemKeranjang(item: item, cart: cart);
                },
              ),
            ),
            _RingkasanBayar(cart: cart),
          ],
        );
      }),
    );
  }

  void _konfirmasiKosongkan(CartController cart) {
    Get.dialog(
      AlertDialog(
        title: const Text('Kosongkan keranjang'),
        content: const Text(
            'Semua item di keranjang akan dihapus. Lanjutkan tindakan ini.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              cart.kosongkanKeranjang();
              Get.back();
            },
            child: const Text('Ya, kosongkan'),
          ),
        ],
      ),
    );
  }
}

class _KeranjangKosong extends StatelessWidget {
  const _KeranjangKosong();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.shopping_cart_outlined,
                  size: 60, color: Colors.blue.shade700),
            ),
            const SizedBox(height: 16),
            const Text(
              'Keranjang masih kosong',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tambahkan produk dari halaman beranda untuk memulai belanja.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemKeranjang extends StatelessWidget {
  final CartItem item;
  final CartController cart;

  const _ItemKeranjang({required this.item, required this.cart});

  @override
  Widget build(BuildContext context) {
    final produk = item.produk;
    final diskon = produk is DiscountedProduct ? produk : null;
    final hargaFinal = diskon?.getHargaFinal() ?? produk.price;
    final skema = Theme.of(context).colorScheme;
    final toko = TokoTema.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: skema.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: skema.shadow.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: toko.netralMuda,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.image_outlined, color: toko.netral, size: 28),
          ),
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
                const SizedBox(height: 4),
                Text(
                  formatRupiah(hargaFinal),
                  style: TextStyle(
                      color: toko.harga, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _TombolQty(
                      icon: Icons.remove,
                      onTap: () => cart.kurangQty(item),
                    ),
                    Container(
                      width: 36,
                      alignment: Alignment.center,
                      child: Obx(() => Text(
                            item.jumlah.value.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                    _TombolQty(
                      icon: Icons.add,
                      onTap: () => cart.tambahQty(item),
                    ),
                    const Spacer(),
                    Obx(() => Text(
                          formatRupiah(item.subtotal),
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Hapus item',
            icon: Icon(Icons.close, color: skema.error),
            onPressed: () => cart.removeFromCart(produk),
          ),
        ],
      ),
    );
  }
}

class _TombolQty extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _TombolQty({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: skema.primaryContainer,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, size: 16, color: skema.onPrimaryContainer),
      ),
    );
  }
}

class _RingkasanBayar extends StatelessWidget {
  final CartController cart;
  const _RingkasanBayar({required this.cart});

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: skema.surface,
        border: Border(top: BorderSide(color: skema.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total belanja',
                  style: TextStyle(fontSize: 13, color: skema.onSurfaceVariant),
                ),
                Obx(() => Text(
                      formatRupiah(cart.totalHarga),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () async {
                  final uid = Get.find<AuthController>().user.value?.uid;
                  if (uid == null) {
                    Get.snackbar('Belum masuk', 'Silakan masuk dulu sebelum checkout');
                    return;
                  }
                  final order = await OrderService.instance
                      .simpanDariKeranjang(cart, uid);
                  Get.off(() => CheckoutPage(order: order));
                },
                icon: const Icon(Icons.payments_outlined),
                label: const Text('Checkout sekarang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
