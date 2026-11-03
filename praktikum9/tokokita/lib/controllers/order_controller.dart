import 'package:get/get.dart';

import '../database/order_database.dart';
import '../models/order_model.dart';
import 'cart_controller.dart';

class OrderController extends GetxController {
  final OrderDatabase _db = OrderDatabase.instance;

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxString filterStatus = ''.obs;
  final RxString kataKunci = ''.obs;

  @override
  void onInit() {
    super.onInit();
    muat();
  }

  Future<void> muat() async {
    final hasil = await _db.getAllOrders(
      status: filterStatus.value,
      kataKunci: kataKunci.value,
    );
    orders.assignAll(hasil);
  }

  Future<void> setFilter(String status) async {
    filterStatus.value = status;
    await muat();
  }

  Future<void> cari(String kata) async {
    kataKunci.value = kata;
    await muat();
  }

  Future<OrderModel> simpanDariKeranjang(CartController cart) async {
    final baris = cart.items
        .map((it) => '${it.produk.name} x ${it.jumlah.value}')
        .join('\n');
    final order = OrderModel(
      tanggal: DateTime.now().toIso8601String(),
      daftarItem: baris,
      totalHarga: cart.totalHarga,
      status: 'Diproses',
    );
    final id = await _db.insertOrder(order);
    cart.kosongkanKeranjang();
    await muat();
    return OrderModel(
      id: id,
      tanggal: order.tanggal,
      daftarItem: order.daftarItem,
      totalHarga: order.totalHarga,
      status: order.status,
    );
  }

  Future<void> ubahStatus(OrderModel order, String statusBaru) async {
    if (order.id == null) return;
    await _db.updateOrderStatus(order.id!, statusBaru);
    await muat();
  }

  Future<void> hapus(OrderModel order) async {
    if (order.id == null) return;
    await _db.deleteOrder(order.id!);
    await muat();
  }
}
