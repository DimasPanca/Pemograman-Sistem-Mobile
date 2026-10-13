import 'package:get/get.dart';

import '../models/product.dart';

class CartItem {
  final Product produk;
  final RxInt jumlah;

  CartItem({required this.produk, int jumlah = 1}) : jumlah = jumlah.obs;

  double get subtotal {
    final diskon = produk is DiscountedProduct ? produk as DiscountedProduct : null;
    final hargaFinal = diskon?.getHargaFinal() ?? produk.price;
    return hargaFinal * jumlah.value;
  }
}

class CartController extends GetxController {
  final RxList<CartItem> items = <CartItem>[].obs;

  int get totalItem => items.fold(0, (sum, it) => sum + it.jumlah.value);

  double get totalHarga => items.fold(0.0, (sum, it) => sum + it.subtotal);

  void addToCart(Product produk, {int jumlah = 1}) {
    final existing = items.firstWhereOrNull((it) => it.produk.id == produk.id);
    if (existing != null) {
      existing.jumlah.value += jumlah;
      items.refresh();
    } else {
      items.add(CartItem(produk: produk, jumlah: jumlah));
    }
  }

  void removeFromCart(Product produk) {
    items.removeWhere((it) => it.produk.id == produk.id);
  }

  void tambahQty(CartItem item) {
    if (item.jumlah.value < item.produk.stock) {
      item.jumlah.value++;
      items.refresh();
    }
  }

  void kurangQty(CartItem item) {
    if (item.jumlah.value > 1) {
      item.jumlah.value--;
      items.refresh();
    } else {
      removeFromCart(item.produk);
    }
  }

  void kosongkanKeranjang() {
    items.clear();
  }
}
