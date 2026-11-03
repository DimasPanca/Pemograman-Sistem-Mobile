import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../theme/app_theme.dart';
import '../widgets/add_to_cart_button.dart';
import '../widgets/product_card.dart';

class ProductDetailPage extends StatefulWidget {
  final Product produk;

  const ProductDetailPage({super.key, required this.produk});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final CartController cart = Get.find<CartController>();
  final ProductService _service = ProductService();
  int jumlah = 1;
  String _pesanTerakhir = '';
  Product? _detailServer;
  bool _memuat = false;

  Product get _produk => _detailServer ?? widget.produk;

  @override
  void initState() {
    super.initState();
    _muatDetail();
  }

  Future<void> _muatDetail() async {
    final id = int.tryParse(widget.produk.id);
    if (id == null) return;
    setState(() => _memuat = true);
    try {
      final hasil = await _service.fetchProductDetail(id);
      if (!mounted) return;
      setState(() => _detailServer = hasil);
    } catch (_) {
      // data dari navigasi tetap dipakai kalau request gagal
    } finally {
      if (mounted) setState(() => _memuat = false);
    }
  }

  void _tambah() {
    if (jumlah < _produk.stock) {
      setState(() => jumlah++);
    }
  }

  void _kurang() {
    if (jumlah > 1) {
      setState(() => jumlah--);
    }
  }

  void _tambahKeKeranjang() {
    _pesanTerakhir = '$jumlah ${_produk.name} ditambahkan ke keranjang';
    cart.addToCart(_produk, jumlah: jumlah);
  }

  // Dipanggil setelah animasi tombol selesai
  void _selesaiMenambah() {
    final warnaLatar = TokoTema.of(context).sukses;
    final warnaTeks = Theme.of(context).colorScheme.onPrimary;
    // Get.back harus dipanggil sebelum snackbar, kalau tidak hanya snackbar yang tertutup
    Get.back();
    Get.snackbar(
      'Masuk keranjang',
      _pesanTerakhir,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: warnaLatar,
      colorText: warnaTeks,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final produk = _produk;
    final diskon = produk is DiscountedProduct ? produk : null;
    final hargaFinal = diskon?.getHargaFinal() ?? produk.price;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text('Detail Produk'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () {},
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: Obx(() {
                    final jml = cart.totalItem;
                    if (jml == 0) return const SizedBox.shrink();
                    return Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                          minWidth: 16, minHeight: 16),
                      child: Text(
                        jml.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onError,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_memuat)
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: LinearProgressIndicator(minHeight: 3),
            ),
          _KartuGambar(produk: produk),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(produk.name, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 6),
                Row(
                  children: [
                    CategoryTag(category: produk.category),
                    const SizedBox(width: 6),
                    StockBadge(status: produk.getStatusStok()),
                  ],
                ),
                const SizedBox(height: 10),
                PriceLabel(harga: hargaFinal, hargaAsli: diskon?.price),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  'Deskripsi',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  produk.description ?? 'Belum ada deskripsi untuk produk ini.',
                  style: const TextStyle(fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 14),
                _InfoBaris(label: 'ID Produk', nilai: produk.id),
                _InfoBaris(
                    label: 'Stok tersedia', nilai: produk.stock.toString()),
                if (diskon != null)
                  _InfoBaris(
                      label: 'Diskon',
                      nilai:
                          '${diskon.discountPercent.toStringAsFixed(0)} persen'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _PemilihJumlah(
            jumlah: jumlah,
            onTambah: _tambah,
            onKurang: _kurang,
            maksimal: produk.stock,
          ),
          const SizedBox(height: 16),
          AddToCartButton(
            aktif: produk.stock > 0,
            label: produk.stock > 0
                ? 'Tambah $jumlah ke Keranjang'
                : 'Stok Habis',
            onTambah: _tambahKeKeranjang,
            onSelesai: _selesaiMenambah,
          ),
        ],
      ),
    );
  }
}

class _KartuGambar extends StatelessWidget {
  final Product produk;
  const _KartuGambar({required this.produk});

  @override
  Widget build(BuildContext context) {
    final diskon = produk is DiscountedProduct ? produk as DiscountedProduct : null;
    final skema = Theme.of(context).colorScheme;
    final toko = TokoTema.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Hero(
          tag: 'product-image-${produk.id}',
          child: Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: toko.netralMuda,
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: produk.imageUrl.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.network(
                      produk.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => Center(
                        child: Icon(Icons.broken_image_outlined,
                            size: 70, color: toko.netral),
                      ),
                    ),
                  )
                : Center(
                    child: Icon(Icons.image_outlined,
                        size: 90, color: toko.netral),
                  ),
          ),
        ),
        if (diskon != null)
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: skema.error,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Diskon ${diskon.discountPercent.toStringAsFixed(0)}%',
                style: TextStyle(
                    color: skema.onError,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }
}

class _InfoBaris extends StatelessWidget {
  final String label;
  final String nilai;
  const _InfoBaris({required this.label, required this.nilai});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
          Expanded(
            child: Text(
              nilai,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _PemilihJumlah extends StatelessWidget {
  final int jumlah;
  final int maksimal;
  final VoidCallback onTambah;
  final VoidCallback onKurang;

  const _PemilihJumlah({
    required this.jumlah,
    required this.maksimal,
    required this.onTambah,
    required this.onKurang,
  });

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: skema.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: skema.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Jumlah',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Row(
            children: [
              _TombolBulat(
                icon: Icons.remove,
                aktif: jumlah > 1,
                onPressed: onKurang,
              ),
              Container(
                width: 44,
                alignment: Alignment.center,
                child: Text(
                  jumlah.toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              _TombolBulat(
                icon: Icons.add,
                aktif: jumlah < maksimal,
                onPressed: onTambah,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TombolBulat extends StatelessWidget {
  final IconData icon;
  final bool aktif;
  final VoidCallback onPressed;

  const _TombolBulat({
    required this.icon,
    required this.aktif,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return InkWell(
      onTap: aktif ? onPressed : null,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: aktif ? skema.primaryContainer : skema.outlineVariant,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          size: 18,
          color: aktif ? skema.onPrimaryContainer : skema.outline,
        ),
      ),
    );
  }
}
