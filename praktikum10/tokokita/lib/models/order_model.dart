import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String? id;
  final String uid;
  final String tanggal;
  final String daftarItem;
  final double totalHarga;
  final String status;

  const OrderModel({
    this.id,
    required this.uid,
    required this.tanggal,
    required this.daftarItem,
    required this.totalHarga,
    required this.status,
  });

  Map<String, Object?> toFirestore() => {
        'uid': uid,
        'daftarItem': daftarItem,
        'totalHarga': totalHarga,
        'tanggal': Timestamp.fromDate(DateTime.parse(tanggal)),
        'status': status,
      };

  factory OrderModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? <String, dynamic>{};
    final ts = d['tanggal'];
    final waktu = ts is Timestamp ? ts.toDate() : DateTime.now();
    return OrderModel(
      id: doc.id,
      uid: d['uid'] as String? ?? '',
      tanggal: waktu.toIso8601String(),
      daftarItem: d['daftarItem'] as String? ?? '',
      totalHarga: (d['totalHarga'] as num?)?.toDouble() ?? 0,
      status: d['status'] as String? ?? 'Diproses',
    );
  }

  String get kodePendek {
    final kode = id ?? '------';
    return kode.length > 6 ? kode.substring(kode.length - 6).toUpperCase() : kode;
  }

  String get tanggalTampil {
    final t = DateTime.tryParse(tanggal);
    if (t == null) return tanggal;
    const bulan = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    String dua(int n) => n.toString().padLeft(2, '0');
    return '${t.day} ${bulan[t.month - 1]} ${t.year}, ${dua(t.hour)}.${dua(t.minute)}';
  }
}
