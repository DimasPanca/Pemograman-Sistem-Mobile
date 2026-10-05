import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/product_card.dart';

class ProductDetailPage extends StatefulWidget {
  final Product produk;

  const ProductDetailPage({super.key, required this.produk});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int jumlah = 1;

  void _tambah() {
    if (jumlah < widget.produk.stock) {
      setState(() => jumlah++);
    }
  }

  void _kurang() {
    if (jumlah > 1) {
      setState(() => jumlah--);
    }
  }

  void _tambahKeKeranjang() {
    Navigator.pop(context, jumlah);
  }

  @override
  Widget build(BuildContext context) {
    final produk = widget.produk;
    final diskon = produk is DiscountedProduct ? produk : null;
    final hargaFinal = diskon?.getHargaFinal() ?? produk.price;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _KartuGambar(produk: produk),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produk.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
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
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: produk.stock > 0 ? _tambahKeKeranjang : null,
              icon: const Icon(Icons.add_shopping_cart),
              label: Text(produk.stock > 0
                  ? 'Tambah $jumlah ke Keranjang'
                  : 'Stok Habis'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.blue.shade700,
              ),
            ),
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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 220,
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Icon(Icons.image_outlined,
                size: 90, color: Colors.blueGrey),
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
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Diskon ${diskon.discountPercent.toStringAsFixed(0)}%',
                style: const TextStyle(
                    color: Colors.white,
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
              style:
                  const TextStyle(fontSize: 13, color: Colors.black54),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
    return InkWell(
      onTap: aktif ? onPressed : null,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: aktif ? Colors.blue.shade50 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          size: 18,
          color: aktif ? Colors.blue.shade800 : Colors.grey,
        ),
      ),
    );
  }
}
