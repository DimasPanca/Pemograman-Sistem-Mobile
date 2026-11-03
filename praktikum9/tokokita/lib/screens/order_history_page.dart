import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/order_controller.dart';
import '../models/order_model.dart';
import '../models/product.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<OrderController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          _Pencarian(ctrl: ctrl),
          Expanded(
            child: Obx(() {
              if (ctrl.orders.isEmpty) return const _Kosong();
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                itemCount: ctrl.orders.length,
                itemBuilder: (context, i) =>
                    _KartuPesanan(order: ctrl.orders[i], ctrl: ctrl),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _Pencarian extends StatelessWidget {
  final OrderController ctrl;
  const _Pencarian({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    const pilihan = ['', 'Diproses', 'Selesai'];
    const label = ['Semua', 'Diproses', 'Selesai'];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      child: Column(
        children: [
          TextField(
            onChanged: ctrl.cari,
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Cari nama produk di pesanan',
              prefixIcon: const Icon(Icons.search, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => Row(
                children: List.generate(pilihan.length, (i) {
                  final aktif = ctrl.filterStatus.value == pilihan[i];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(label[i]),
                      selected: aktif,
                      onSelected: (_) => ctrl.setFilter(pilihan[i]),
                    ),
                  );
                }),
              )),
        ],
      ),
    );
  }
}

class _Kosong extends StatelessWidget {
  const _Kosong();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined, size: 56, color: Colors.black26),
          SizedBox(height: 10),
          Text('Belum ada riwayat pesanan',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _KartuPesanan extends StatelessWidget {
  final OrderModel order;
  final OrderController ctrl;

  const _KartuPesanan({required this.order, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final selesai = order.status == 'Selesai';
    final warna = selesai ? Colors.green : Colors.orange;
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pesanan #${order.id}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: warna.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: warna),
                ),
                child: Text(order.status,
                    style: TextStyle(
                        color: warna,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(order.tanggalTampil,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 8),
          Text(order.daftarItem, style: const TextStyle(fontSize: 13)),
          const Divider(height: 18),
          Row(
            children: [
              Text(formatRupiah(order.totalHarga),
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
              const Spacer(),
              if (!selesai)
                TextButton.icon(
                  onPressed: () => ctrl.ubahStatus(order, 'Selesai'),
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Tandai selesai'),
                ),
              IconButton(
                tooltip: 'Hapus pesanan',
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => ctrl.hapus(order),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
