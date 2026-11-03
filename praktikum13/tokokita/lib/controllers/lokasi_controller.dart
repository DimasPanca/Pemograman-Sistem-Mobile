// ignore_for_file: avoid_print

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/izin_service.dart';

class Koordinat {
  final double lat;
  final double lng;

  const Koordinat(this.lat, this.lng);

  String get teks => '${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}';
}

/// Menyimpan alamat pengiriman sementara berupa koordinat GPS untuk checkout.
class LokasiController extends GetxController {
  final Rxn<Koordinat> lokasi = Rxn<Koordinat>();
  final RxBool memuat = false.obs;

  Future<void> ambil() async {
    memuat.value = true;
    try {
      final izin = await IzinService.instance.pastikan(
        Permission.location,
        judul: 'Lokasi',
        alasan: 'TokoKita memakai lokasi Anda hanya untuk mengisi alamat '
            'pengiriman pada pesanan ini.',
      );
      if (!izin) return;

      if (!await Geolocator.isLocationServiceEnabled()) {
        Get.snackbar('GPS mati', 'Aktifkan layanan lokasi lalu coba lagi.');
        return;
      }
      var status = await Geolocator.checkPermission();
      if (status == LocationPermission.denied) {
        status = await Geolocator.requestPermission();
      }
      if (status == LocationPermission.denied ||
          status == LocationPermission.deniedForever) {
        Get.snackbar('Izin lokasi ditolak', 'Lokasi tidak bisa diambil.');
        return;
      }

      final posisi = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      lokasi.value = Koordinat(posisi.latitude, posisi.longitude);
      print('Lokasi didapat lat=${posisi.latitude} lng=${posisi.longitude}');
    } catch (e) {
      print('Lokasi gagal $e');
      Get.snackbar('Lokasi gagal', 'Posisi belum bisa diambil, coba lagi.');
    } finally {
      memuat.value = false;
    }
  }

  void hapus() => lokasi.value = null;
}
