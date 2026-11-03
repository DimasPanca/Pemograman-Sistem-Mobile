import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';

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

  // Ambang guncangan sekitar 2,5 g, dengan jeda supaya tidak memuat berulang
  static const double _ambangGuncang = 25;
  static const Duration _jedaGuncang = Duration(seconds: 3);
  StreamSubscription<AccelerometerEvent>? _sensor;
  final ValueNotifier<AccelerometerEvent?> _percepatan = ValueNotifier(null);
  DateTime _guncangTerakhir = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    _future = _service.fetchProducts();
    _mulaiSensor();
  }

  @override
  void dispose() {
    _sensor?.cancel();
    _percepatan.dispose();
    super.dispose();
  }

  void _mulaiSensor() {
    try {
      _sensor = accelerometerEventStream().listen(
        _olahSensor,
        onError: (Object e) => debugPrint('Sensor tidak tersedia $e'),
      );
    } catch (e) {
      debugPrint('Sensor gagal dimulai $e');
    }
  }

  void _olahSensor(AccelerometerEvent e) {
    _percepatan.value = e;
    final besar = math.sqrt(e.x * e.x + e.y * e.y + e.z * e.z);
    final sekarang = DateTime.now();
    if (besar > _ambangGuncang &&
        sekarang.difference(_guncangTerakhir) > _jedaGuncang) {
      _guncangTerakhir = sekarang;
      debugPrint('Guncangan terdeteksi besar=${besar.toStringAsFixed(1)}');
      Get.snackbar(
        'Memuat ulang produk...',
        'Guncangan terdeteksi',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      _reload();
    }
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _AppHeader(),
            const _Sapaan(),
            _BarSensor(data: _percepatan),
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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text('Memuat produk dari server...',
              style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
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
    final skema = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: skema.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.cloud_off, size: 48, color: skema.error),
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
              style: TextStyle(fontSize: 12, color: skema.onSurfaceVariant),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: onCobaLagi,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
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
    final tema = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      color: tema.colorScheme.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: tema.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.storefront,
                    color: tema.colorScheme.primary, size: 22),
              ),
              const SizedBox(width: 10),
              Text('TokoKita', style: tema.textTheme.titleLarge),
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
                    decoration: BoxDecoration(
                      color: tema.colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                    constraints:
                        const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      jumlah.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: tema.colorScheme.onError,
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

class _BarSensor extends StatelessWidget {
  final ValueListenable<AccelerometerEvent?> data;

  const _BarSensor({required this.data});

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      color: skema.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: ValueListenableBuilder<AccelerometerEvent?>(
        valueListenable: data,
        builder: (context, e, _) {
          final teks = e == null
              ? 'Menunggu data accelerometer'
              : 'x ${e.x.toStringAsFixed(1)}   y ${e.y.toStringAsFixed(1)}   z ${e.z.toStringAsFixed(1)}';
          return Row(
            children: [
              Icon(Icons.sensors, size: 16, color: skema.primary),
              const SizedBox(width: 6),
              Text('Accelerometer  $teks',
                  style: TextStyle(fontSize: 12, color: skema.onSurfaceVariant)),
            ],
          );
        },
      ),
    );
  }
}

class _Sapaan extends StatelessWidget {
  const _Sapaan();

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Container(
      width: double.infinity,
      color: tema.colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Halo, Dimas',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            'Belanja jadi lebih mudah bareng TokoKita',
            style: TextStyle(
                fontSize: 13, color: tema.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
