import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../models/order_model.dart';
import '../models/product.dart';
import '../services/order_service.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final AuthController auth = Get.find<AuthController>();
  late final Stream<List<OrderModel>> _stream;
  String _status = '';
  String _kata = '';

  @override
  void initState() {
    super.initState();
    final uid = auth.user.value?.uid ?? '';
    _stream = OrderService.instance.streamOrders(uid);
  }

  List<OrderModel> _saring(List<OrderModel> semua) {
    return semua.where((o) {
      final cocokStatus = _status.isEmpty || o.status == _status;
      final cocokKata = _kata.isEmpty ||
          o.daftarItem.toLowerCase().contains(_kata.toLowerCase());
      return cocokStatus && cocokKata;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    const pilihan = ['', 'Diproses', 'Selesai'];
    const label = ['Semua', 'Diproses', 'Selesai'];
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
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
            child: Column(
              children: [
                TextField(
                  onChanged: (v) => setState(() => _kata = v.trim()),
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
                Row(
                  children: List.generate(pilihan.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(label[i]),
                        selected: _status == pilihan[i],
                        onSelected: (_) =>
                            setState(() => _status = pilihan[i]),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<OrderModel>>(
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text('Gagal memuat riwayat\n${snapshot.error}',
                          textAlign: TextAlign.center),
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final daftar = _saring(snapshot.data!);
                if (daftar.isEmpty) return const _Kosong();
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                  itemCount: daftar.length,
                  itemBuilder: (context, i) => _KartuPesanan(order: daftar[i]),
                );
              },
            ),
          ),
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

  const _KartuPesanan({required this.order});

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
              Text('Pesanan #${order.kodePendek}',
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
                  onPressed: () => OrderService.instance
                      .ubahStatus(order.id!, 'Selesai'),
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Tandai selesai'),
                ),
              IconButton(
                tooltip: 'Hapus pesanan',
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => OrderService.instance.hapus(order.id!),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
