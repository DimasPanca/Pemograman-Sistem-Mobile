// ignore_for_file: avoid_print

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/order_model.dart';

class OrderDatabase {
  OrderDatabase._();
  static final OrderDatabase instance = OrderDatabase._();

  static const String _namaTabel = 'orders';
  Database? _db;

  Future<Database> get database async {
    return _db ??= await _buka();
  }

  Future<Database> _buka() async {
    final folder = await getDatabasesPath();
    final lokasi = join(folder, 'tokokita.db');
    final db = await openDatabase(
      lokasi,
      version: 1,
      onCreate: (db, versi) async {
        await db.execute('''
          CREATE TABLE $_namaTabel (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tanggal TEXT NOT NULL,
            daftarItem TEXT NOT NULL,
            totalHarga REAL NOT NULL,
            status TEXT NOT NULL
          )
        ''');
        print('SQLite tabel $_namaTabel berhasil dibuat');
      },
    );
    print('SQLite database siap di $lokasi');
    return db;
  }

  Future<int> insertOrder(OrderModel order) async {
    final db = await database;
    final id = await db.insert(_namaTabel, order.toMap());
    print('SQLite insert order id=$id total=${order.totalHarga}');
    return id;
  }

  Future<List<OrderModel>> getAllOrders({
    String? status,
    String? kataKunci,
  }) async {
    final db = await database;
    final kondisi = <String>[];
    final argumen = <Object?>[];
    if (status != null && status.isNotEmpty) {
      kondisi.add('status = ?');
      argumen.add(status);
    }
    if (kataKunci != null && kataKunci.trim().isNotEmpty) {
      kondisi.add('daftarItem LIKE ?');
      argumen.add('%${kataKunci.trim()}%');
    }
    final hasil = await db.query(
      _namaTabel,
      where: kondisi.isEmpty ? null : kondisi.join(' AND '),
      whereArgs: argumen.isEmpty ? null : argumen,
      orderBy: 'id DESC',
    );
    print('SQLite getAllOrders status=${status ?? "semua"} '
        'kata="${kataKunci ?? ""}" -> ${hasil.length} baris');
    return hasil.map(OrderModel.fromMap).toList();
  }

  Future<int> updateOrderStatus(int id, String statusBaru) async {
    final db = await database;
    final n = await db.update(
      _namaTabel,
      {'status': statusBaru},
      where: 'id = ?',
      whereArgs: [id],
    );
    print('SQLite update order id=$id status=$statusBaru ($n baris)');
    return n;
  }

  Future<int> deleteOrder(int id) async {
    final db = await database;
    final n = await db.delete(_namaTabel, where: 'id = ?', whereArgs: [id]);
    print('SQLite delete order id=$id ($n baris)');
    return n;
  }
}
