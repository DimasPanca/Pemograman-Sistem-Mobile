import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/order_model.dart';
import '../models/product.dart';
import 'main_page.dart';
import 'order_history_page.dart';

class CheckoutPage extends StatelessWidget {
  final OrderModel order;

  const CheckoutPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Pesanan Berhasil'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Icon(Icons.check_circle,
                    size: 56, color: Colors.green.shade600),
                const SizedBox(height: 8),
                const Text('Pesanan tersimpan',
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text('Nomor pesanan #${order.kodePendek}',
                    style: const TextStyle(
                        fontSize: 13, color: Colors.black54)),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Daftar item',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(order.daftarItem, style: const TextStyle(height: 1.5)),
                const Divider(height: 22),
                _baris('Tanggal', order.tanggalTampil),
                const SizedBox(height: 6),
                _baris('Status', order.status),
                const SizedBox(height: 6),
                _baris('Total bayar', formatRupiah(order.totalHarga),
                    tebal: true),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            icon: const Icon(Icons.receipt_long_outlined),
            label: const Text('Lihat Riwayat Pesanan'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {
              Get.offAll(() => const MainPage());
              Get.to(() => const OrderHistoryPage());
            },
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () => Get.offAll(() => const MainPage()),
            child: const Text('Kembali ke Beranda'),
          ),
        ],
      ),
    );
  }

  Widget _baris(String label, String nilai, {bool tebal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54)),
        Text(nilai,
            style: TextStyle(
                fontWeight: tebal ? FontWeight.bold : FontWeight.w600,
                fontSize: tebal ? 16 : 14)),
      ],
    );
  }
}
