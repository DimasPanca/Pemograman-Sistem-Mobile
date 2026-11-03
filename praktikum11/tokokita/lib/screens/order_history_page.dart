import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../models/order_model.dart';
import '../models/product.dart';
import '../services/order_service.dart';
import '../theme/app_theme.dart';

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
    final skema = Theme.of(context).colorScheme;
    const pilihan = ['', 'Diproses', 'Selesai'];
    const label = ['Semua', 'Diproses', 'Selesai'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: skema.surface,
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
                  itemBuilder: (context, i) => _KartuPesanan(
                      key: ValueKey(daftar[i].id), order: daftar[i]),
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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 56, color: Theme.of(context).colorScheme.outlineVariant),
          const SizedBox(height: 10),
          const Text('Belum ada riwayat pesanan',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _KartuPesanan extends StatelessWidget {
  final OrderModel order;

  const _KartuPesanan({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    final toko = TokoTema.of(context);
    final selesai = order.status == 'Selesai';
    final warna = selesai ? toko.sukses : toko.peringatan;
    return Container(
      margin: const EdgeInsets.only(top: 8),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pesanan #${order.kodePendek}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              // animasi implisit, warna badge berubah halus saat status berganti
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: warna.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: warna),
                ),
                child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                    style: TextStyle(
                        color: warna,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                    child: Text(order.status)),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(order.tanggalTampil,
              style: TextStyle(fontSize: 12, color: skema.onSurfaceVariant)),
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
                icon: Icon(Icons.delete_outline, color: skema.error),
                onPressed: () => OrderService.instance.hapus(order.id!),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
