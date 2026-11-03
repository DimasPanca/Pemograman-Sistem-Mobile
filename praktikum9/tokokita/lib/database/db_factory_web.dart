import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

// Di web sqflite butuh adaptor berbasis sqlite3.wasm.
Future<void> initDatabaseFactory() async {
  databaseFactory = databaseFactoryFfiWebNoWebWorker;
}
