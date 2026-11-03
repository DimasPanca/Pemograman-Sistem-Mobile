// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

import '../controllers/cart_controller.dart';
import '../models/order_model.dart';

class OrderService {
  OrderService._();
  static final OrderService instance = OrderService._();

  CollectionReference<Map<String, dynamic>> get _koleksi =>
      FirebaseFirestore.instance.collection('orders');

  Future<OrderModel> simpanDariKeranjang(
    CartController cart,
    String uid, {
    double? latitude,
    double? longitude,
  }) async {
    final baris = cart.items
        .map((it) => '${it.produk.name} x ${it.jumlah.value}')
        .join('\n');
    final order = OrderModel(
      uid: uid,
      tanggal: DateTime.now().toIso8601String(),
      daftarItem: baris,
      totalHarga: cart.totalHarga,
      status: 'Diproses',
      latitude: latitude,
      longitude: longitude,
    );
    final ref = await _koleksi.add(order.toFirestore());
    print('Firestore tambah order ${ref.id} uid=$uid total=${order.totalHarga} '
        'lokasi=${order.alamatTampil ?? "tanpa lokasi"}');
    cart.kosongkanKeranjang();
    return OrderModel(
      id: ref.id,
      uid: uid,
      tanggal: order.tanggal,
      daftarItem: order.daftarItem,
      totalHarga: order.totalHarga,
      status: order.status,
      latitude: latitude,
      longitude: longitude,
    );
  }

  // Query hanya memakai where uid supaya tidak butuh composite index,
  // pengurutan terbaru di atas dilakukan di sisi aplikasi.
  Stream<List<OrderModel>> streamOrders(String uid) {
    return _koleksi.where('uid', isEqualTo: uid).snapshots().map((snap) {
      final daftar = snap.docs.map(OrderModel.fromDoc).toList()
        ..sort((a, b) => b.tanggal.compareTo(a.tanggal));
      print('Firestore stream orders uid=$uid -> ${daftar.length} dokumen');
      return daftar;
    });
  }

  Future<void> ubahStatus(String id, String statusBaru) async {
    await _koleksi.doc(id).update({'status': statusBaru});
    print('Firestore update order $id status=$statusBaru');
  }

  Future<void> hapus(String id) async {
    await _koleksi.doc(id).delete();
    print('Firestore hapus order $id');
  }
}
