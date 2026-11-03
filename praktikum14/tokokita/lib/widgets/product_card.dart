import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/wishlist_controller.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';

class PriceLabel extends StatelessWidget {
  final double harga;
  final double? hargaAsli;

  const PriceLabel({super.key, required this.harga, this.hargaAsli});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    if (hargaAsli != null && hargaAsli! > harga) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            formatRupiah(hargaAsli!),
            style: TextStyle(
              fontSize: 11,
              color: tema.colorScheme.outline,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          Text(
            formatRupiah(harga),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: TokoTema.of(context).harga,
            ),
          ),
        ],
      );
    }
    return Text(
      formatRupiah(harga),
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

class StockBadge extends StatelessWidget {
  final String status;

  const StockBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final toko = TokoTema.of(context);
    final warna = switch (status) {
      'Tersedia' => toko.sukses,
      'Stok Terbatas' => toko.peringatan,
      _ => Theme.of(context).colorScheme.error,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: warna.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: warna),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: warna,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class CategoryTag extends StatelessWidget {
  final String category;

  const CategoryTag({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final netral = TokoTema.of(context).netral;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: netral.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        category,
        style: TextStyle(fontSize: 11, color: netral),
      ),
    );
  }
}

/// Memunculkan badge secara halus (fade in) saat pertama kali tampil.
class FadeInBadge extends StatefulWidget {
  final Widget child;

  const FadeInBadge({super.key, required this.child});

  @override
  State<FadeInBadge> createState() => _FadeInBadgeState();
}

class _FadeInBadgeState extends State<FadeInBadge> {
  bool _tampil = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _tampil = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _tampil ? 1 : 0,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeIn,
      child: widget.child,
    );
  }
}

/// Ikon favorit yang membesar sesaat (efek pop) ketika ditekan.
class HeartButton extends StatefulWidget {
  final bool favorit;
  final VoidCallback onTap;

  const HeartButton({super.key, required this.favorit, required this.onTap});

  @override
  State<HeartButton> createState() => _HeartButtonState();
}

class _HeartButtonState extends State<HeartButton> {
  double _skala = 1.0;

  void _tekan() {
    widget.onTap();
    setState(() => _skala = 1.4);
    Future.delayed(const Duration(milliseconds: 160), () {
      if (mounted) setState(() => _skala = 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return IconButton(
      onPressed: _tekan,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      tooltip: 'Tandai favorit',
      icon: AnimatedScale(
        scale: _skala,
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutBack,
        child: Icon(
          widget.favorit ? Icons.favorite : Icons.favorite_border,
          color: widget.favorit ? skema.error : skema.outline,
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product produk;

  const ProductCard({super.key, required this.produk});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final WishlistController wishlist = Get.find<WishlistController>();

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final produk = widget.produk;
    final diskonProduk = produk is DiscountedProduct ? produk : null;
    final statusStok = produk.getStatusStok();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tema.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: tema.colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGambarDenganBadge(context, diskonProduk, statusStok),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produk.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tema.textTheme.titleMedium,
                ),
                CategoryTag(category: produk.category),
                Text(
                  produk.description ?? 'Belum ada deskripsi',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: tema.textTheme.bodySmall,
                ),
                const SizedBox(height: 6),
                Text('Stok ${produk.stock}', style: tema.textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              PriceLabel(
                harga: diskonProduk?.getHargaFinal() ?? produk.price,
                hargaAsli: diskonProduk?.price,
              ),
              Obx(() => HeartButton(
                    favorit: wishlist.isFavorite(produk.id),
                    onTap: () => wishlist.toggle(produk.id),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGambarDenganBadge(
      BuildContext context, DiscountedProduct? diskonProduk, String statusStok) {
    final skema = Theme.of(context).colorScheme;
    final toko = TokoTema.of(context);
    return SizedBox(
      width: 82,
      height: 90,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Hero(
            tag: 'product-image-${widget.produk.id}',
            child: Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: toko.netralMuda,
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.antiAlias,
              child: widget.produk.imageUrl.isNotEmpty
                  ? Image.network(
                      widget.produk.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => Icon(
                          Icons.broken_image_outlined,
                          size: 32,
                          color: toko.netral),
                      loadingBuilder: (c, child, progress) {
                        if (progress == null) return child;
                        return const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                    )
                  : Icon(Icons.image_outlined, size: 34, color: toko.netral),
            ),
          ),
          if (diskonProduk != null)
            Positioned(
              top: -4,
              right: -4,
              child: FadeInBadge(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: skema.error,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Diskon ${diskonProduk.discountPercent.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: skema.onError,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: -2,
            left: 0,
            right: 0,
            child: Center(
              child: FadeInBadge(child: StockBadge(status: statusStok)),
            ),
          ),
        ],
      ),
    );
  }
}
