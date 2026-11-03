// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'cart_controller.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Rxn<User> user = Rxn<User>();
  final RxBool memproses = false.obs;
  final RxnString pesanError = RxnString();

  @override
  void onInit() {
    super.onInit();
    user.value = _auth.currentUser;
    user.bindStream(_auth.authStateChanges());
  }

  Future<bool> daftar(String email, String password) async {
    return _jalankan(() async {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      print('Auth registrasi berhasil ${email.trim()}');
    });
  }

  Future<bool> masuk(String email, String password) async {
    return _jalankan(() async {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      print('Auth login berhasil ${email.trim()}');
    });
  }

  Future<void> keluar() async {
    await _auth.signOut();
    Get.find<CartController>().kosongkanKeranjang();
    print('Auth logout berhasil');
  }

  Future<bool> _jalankan(Future<void> Function() aksi) async {
    memproses.value = true;
    pesanError.value = null;
    try {
      await aksi();
      return true;
    } on FirebaseAuthException catch (e) {
      print('Auth gagal ${e.code}');
      pesanError.value = _pesan(e);
      return false;
    } finally {
      memproses.value = false;
    }
  }

  String _pesan(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email sudah terdaftar, silakan masuk atau pakai email lain.';
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Email atau password salah.';
      case 'weak-password':
        return 'Password terlalu lemah, minimal 6 karakter.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'network-request-failed':
        return 'Tidak bisa terhubung ke server, periksa koneksi.';
      default:
        return 'Terjadi kesalahan (${e.code}).';
    }
  }
}
