// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

/// Penanganan izin terpusat. Urutannya cek status, jelaskan alasan,
/// minta izin, lalu arahkan ke pengaturan jika ditolak permanen.
class IzinService {
  IzinService._();
  static final IzinService instance = IzinService._();

  Future<bool> pastikan(
    Permission izin, {
    required String judul,
    required String alasan,
  }) async {
    var status = await izin.status;
    print('Izin $judul status awal ${status.name}');
    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      await _dialogPengaturan(judul);
      return false;
    }

    final lanjut = await Get.dialog<bool>(
          AlertDialog(
            title: Text('Izin $judul'),
            content: Text(alasan),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Nanti saja'),
              ),
              FilledButton(
                onPressed: () => Get.back(result: true),
                child: const Text('Lanjutkan'),
              ),
            ],
          ),
        ) ??
        false;
    if (!lanjut) {
      print('Izin $judul dibatalkan pengguna sebelum diminta');
      return false;
    }

    status = await izin.request();
    print('Izin $judul setelah diminta ${status.name}');
    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      await _dialogPengaturan(judul);
    } else {
      Get.snackbar('Izin $judul ditolak', 'Fitur ini tidak bisa dipakai tanpa izin.');
    }
    return false;
  }

  Future<void> _dialogPengaturan(String judul) async {
    final buka = await Get.dialog<bool>(
          AlertDialog(
            title: Text('Izin $judul ditolak'),
            content: Text(
                'Izin $judul sudah ditolak sehingga tidak bisa diminta lagi dari aplikasi. '
                'Aktifkan lewat pengaturan agar fitur ini bisa dipakai.'),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Tutup'),
              ),
              FilledButton(
                onPressed: () => Get.back(result: true),
                child: const Text('Buka Pengaturan'),
              ),
            ],
          ),
        ) ??
        false;
    if (!buka) return;
    final terbuka = await openAppSettings();
    print('openAppSettings hasil $terbuka');
    if (!terbuka) {
      Get.snackbar('Pengaturan tidak terbuka',
          'Ubah izin lewat pengaturan situs pada browser atau pengaturan perangkat.');
    }
  }
}
