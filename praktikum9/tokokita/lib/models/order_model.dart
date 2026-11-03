class OrderModel {
  final int? id;
  final String tanggal;
  final String daftarItem;
  final double totalHarga;
  final String status;

  const OrderModel({
    this.id,
    required this.tanggal,
    required this.daftarItem,
    required this.totalHarga,
    required this.status,
  });

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'tanggal': tanggal,
        'daftarItem': daftarItem,
        'totalHarga': totalHarga,
        'status': status,
      };

  factory OrderModel.fromMap(Map<String, Object?> map) => OrderModel(
        id: map['id'] as int?,
        tanggal: map['tanggal'] as String,
        daftarItem: map['daftarItem'] as String,
        totalHarga: (map['totalHarga'] as num).toDouble(),
        status: map['status'] as String,
      );

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
