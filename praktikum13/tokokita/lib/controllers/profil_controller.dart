// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/izin_service.dart';
import 'auth_controller.dart';

/// Foto profil disimpan per pengguna sebagai base64 pada SharedPreferences.
class ProfilController extends GetxController {
  final Rxn<Uint8List> foto = Rxn<Uint8List>();
  final ImagePicker _picker = ImagePicker();

  String _kunci(String uid) => 'foto_profil_$uid';

  @override
  void onInit() {
    super.onInit();
    final auth = Get.find<AuthController>();
    ever(auth.user, (u) => _muat(u?.uid));
    _muat(auth.user.value?.uid);
  }

  Future<void> _muat(String? uid) async {
    if (uid == null) {
      foto.value = null;
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_kunci(uid));
    foto.value = data == null ? null : base64Decode(data);
    print('Foto profil dimuat untuk $uid ada=${data != null}');
  }

  Future<void> ubahFoto() async {
    final uid = Get.find<AuthController>().user.value?.uid;
    if (uid == null) return;

    final sumber = await Get.dialog<ImageSource>(
      SimpleDialog(
        title: const Text('Ubah foto profil'),
        children: [
          SimpleDialogOption(
            onPressed: () => Get.back(result: ImageSource.camera),
            child: const ListTile(
              leading: Icon(Icons.photo_camera_outlined),
              title: Text('Ambil dari kamera'),
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Get.back(result: ImageSource.gallery),
            child: const ListTile(
              leading: Icon(Icons.photo_library_outlined),
              title: Text('Pilih dari galeri'),
            ),
          ),
        ],
      ),
    );
    if (sumber == null) return;

    if (sumber == ImageSource.camera) {
      final izin = await IzinService.instance.pastikan(
        Permission.camera,
        judul: 'Kamera',
        alasan: 'TokoKita memakai kamera hanya untuk mengambil foto profil Anda.',
      );
      if (!izin) return;
    }

    final berkas = await _picker.pickImage(
      source: sumber,
      maxWidth: 512,
      imageQuality: 75,
    );
    if (berkas == null) {
      print('Pemilihan foto dibatalkan');
      return;
    }
    final bytes = await berkas.readAsBytes();
    foto.value = bytes;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kunci(uid), base64Encode(bytes));
    print('Foto profil disimpan ${bytes.length} byte sumber=${sumber.name}');
  }
}
