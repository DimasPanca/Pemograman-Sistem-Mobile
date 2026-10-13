import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../models/product.dart';
import 'main_page.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final snapshotTotal = cart.totalHarga;
    final snapshotItem = cart.totalItem;
    final snapshotIsi = List<CartItem>.from(cart.items);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      appBar: AppBar(
        title: const Text('Ringkasan Pesanan'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daftar item',
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...snapshotIsi.map((it) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                                '${it.produk.name} x ${it.jumlah.value}'),
                          ),
                          Text(
                            formatRupiah(it.subtotal),
                            style: const TextStyle(
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                _barisInfo('Jumlah item', snapshotItem.toString()),
                const SizedBox(height: 6),
                _barisInfo('Metode pembayaran', 'Transfer bank'),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total bayar',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      formatRupiah(snapshotTotal),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Selesaikan pesanan'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: Colors.green.shade700,
            ),
            onPressed: () {
              cart.kosongkanKeranjang();
              Get.offAll(() => const MainPage());
              Get.snackbar(
                'Pesanan berhasil',
                'Terima kasih sudah berbelanja di TokoKita.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green.shade700,
                colorText: Colors.white,
                margin: const EdgeInsets.all(12),
                duration: const Duration(seconds: 2),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _barisInfo(String label, String nilai) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54)),
        Text(nilai, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
