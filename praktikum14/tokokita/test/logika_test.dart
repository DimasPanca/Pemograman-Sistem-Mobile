import 'package:flutter_test/flutter_test.dart';
import 'package:tokokita/controllers/cart_controller.dart';
import 'package:tokokita/models/product.dart';

const _produk = Product(
  id: 'P1',
  name: 'Kaos Polos',
  price: 100000,
  imageUrl: '',
  category: 'fashion',
  stock: 10,
);

const _produkDiskon = DiscountedProduct(
  id: 'P2',
  name: 'Jaket',
  price: 200000,
  imageUrl: '',
  category: 'fashion',
  stock: 5,
  discountPercent: 10,
);

void main() {
  group('Perhitungan harga dan stok', () {
    test('hitungHargaSetelahDiskon memotong harga sesuai persen', () {
      expect(hitungHargaSetelahDiskon(200000, persenDiskon: 10), 180000);
      expect(hitungHargaSetelahDiskon(200000), 200000);
    });

    test('hitungTotalBelanja menjumlahkan harga seluruh produk', () {
      expect(hitungTotalBelanja([_produk, _produkDiskon]), 300000);
      expect(hitungTotalBelanja([]), 0);
    });

    test('hitungSisaStok tidak pernah di bawah nol', () {
      expect(hitungSisaStok(10, 3), 7);
      expect(hitungSisaStok(2, 5), 0);
    });

    test('getStatusStok mengikuti batas stok', () {
      Product dengan(int stok) => Product(
          id: 'x', name: 'x', price: 1, imageUrl: '', category: 'x', stock: stok);
      expect(dengan(0).getStatusStok(), 'Habis');
      expect(dengan(3).getStatusStok(), 'Stok Terbatas');
      expect(dengan(4).getStatusStok(), 'Tersedia');
    });

    test('Product.fromJson mengonversi harga dolar ke rupiah', () {
      final p = Product.fromJson({
        'id': 1,
        'title': 'Tas',
        'price': 109.95,
        'category': 'tas',
        'image': 'x.png',
        'rating': {'count': 120},
      });
      expect(p.id, '1');
      expect(p.name, 'Tas');
      expect(p.price, closeTo(109.95 * kursUsdKeRupiah, 0.001));
      expect(p.stock, 120);
    });
  });

  group('CartController', () {
    test('menambah produk yang sama menggabungkan jumlahnya', () {
      final cart = CartController();
      cart.addToCart(_produk);
      cart.addToCart(_produk, jumlah: 2);
      expect(cart.items.length, 1);
      expect(cart.totalItem, 3);
      expect(cart.totalHarga, 300000);
    });

    test('total harga memakai harga setelah diskon', () {
      final cart = CartController();
      cart.addToCart(_produk);
      cart.addToCart(_produkDiskon, jumlah: 2);
      expect(cart.totalHarga, 100000 + 2 * 180000);
    });

    test('kurangQty pada jumlah satu menghapus item', () {
      final cart = CartController();
      cart.addToCart(_produk);
      cart.kurangQty(cart.items.first);
      expect(cart.items, isEmpty);
    });
  });
}
