import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tokokita/controllers/wishlist_controller.dart';
import 'package:tokokita/models/product.dart';
import 'package:tokokita/theme/app_theme.dart';
import 'package:tokokita/widgets/add_to_cart_button.dart';
import 'package:tokokita/widgets/product_card.dart';

const _produk = Product(
  id: 'P1',
  name: 'Kaos Polos',
  price: 250000,
  imageUrl: '',
  category: 'fashion',
  stock: 5,
  description: 'Kaos katun yang nyaman dipakai',
);

Widget _bungkus(Widget isi) =>
    MaterialApp(theme: buatTema(), home: Scaffold(body: isi));

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Get.reset();
    Get.put(WishlistController());
  });

  tearDown(Get.reset);

  testWidgets('ProductCard menampilkan nama, kategori, harga, dan stok',
      (tester) async {
    await tester.pumpWidget(_bungkus(const ProductCard(produk: _produk)));

    expect(find.text('Kaos Polos'), findsOneWidget);
    expect(find.text('fashion'), findsOneWidget);
    expect(find.text('Rp 250000'), findsOneWidget);
    expect(find.text('Stok 5'), findsOneWidget);
    expect(find.text('Tersedia'), findsOneWidget);
  });

  testWidgets('ikon favorit pada ProductCard mengubah wishlist saat ditekan',
      (tester) async {
    await tester.pumpWidget(_bungkus(const ProductCard(produk: _produk)));
    final wishlist = Get.find<WishlistController>();

    expect(wishlist.isFavorite('P1'), isFalse);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);

    await tester.tap(find.byTooltip('Tandai favorit'));
    await tester.pump();

    expect(wishlist.isFavorite('P1'), isTrue);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 500));
  });

  testWidgets('PriceLabel menampilkan harga asli dan harga setelah diskon',
      (tester) async {
    await tester.pumpWidget(
      _bungkus(const PriceLabel(harga: 180000, hargaAsli: 200000)),
    );

    expect(find.text('Rp 200000'), findsOneWidget);
    expect(find.text('Rp 180000'), findsOneWidget);
  });

  testWidgets('AddToCartButton memanggil callback dan mengganti ikon ke centang',
      (tester) async {
    var ditambah = 0;
    var selesai = 0;
    await tester.pumpWidget(_bungkus(AddToCartButton(
      label: 'Tambah 1 ke Keranjang',
      onTambah: () => ditambah++,
      onSelesai: () => selesai++,
    )));
    expect(find.text('Tambah 1 ke Keranjang'), findsOneWidget);

    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    expect(ditambah, 1);
    expect(find.text('Ditambahkan'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byIcon(Icons.check), findsOneWidget);
    expect(selesai, 0);

    // animasi 450 ms selesai dulu, baru jeda centang 600 ms berjalan
    await tester.pump(const Duration(milliseconds: 500));
    expect(selesai, 0);
    await tester.pump(const Duration(milliseconds: 700));
    expect(selesai, 1);
    expect(find.text('Tambah 1 ke Keranjang'), findsOneWidget);
    await tester.pumpAndSettle();
  });
}
