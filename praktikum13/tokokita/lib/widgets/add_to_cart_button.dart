import 'package:flutter/material.dart';

/// Tombol tambah ke keranjang dengan animasi eksplisit.
/// Saat ditekan tombol membesar lalu kembali (bounce) dan ikon keranjang
/// berganti menjadi centang sesaat sebelum [onSelesai] dipanggil.
class AddToCartButton extends StatefulWidget {
  final String label;
  final bool aktif;
  final VoidCallback onTambah;
  final VoidCallback? onSelesai;

  const AddToCartButton({
    super.key,
    required this.label,
    required this.onTambah,
    this.aktif = true,
    this.onSelesai,
  });

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _kontrol;
  late final Animation<double> _skala;
  bool _berhasil = false;

  @override
  void initState() {
    super.initState();
    _kontrol = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _skala = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.12).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.12, end: 0.97).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.97, end: 1.0).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(_kontrol);
  }

  @override
  void dispose() {
    _kontrol.dispose();
    super.dispose();
  }

  Future<void> _tekan() async {
    if (_berhasil) return;
    widget.onTambah();
    setState(() => _berhasil = true);
    await _kontrol.forward(from: 0);
    // ikon centang dibiarkan tampil sebentar
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _berhasil = false);
    widget.onSelesai?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _kontrol,
      builder: (context, child) =>
          Transform.scale(scale: _skala.value, child: child),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: widget.aktif ? _tekan : null,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              _berhasil ? Icons.check : Icons.add_shopping_cart,
              key: ValueKey(_berhasil),
            ),
          ),
          label: Text(_berhasil ? 'Ditambahkan' : widget.label),
        ),
      ),
    );
  }
}
