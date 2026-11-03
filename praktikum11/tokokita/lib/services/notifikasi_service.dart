// ignore_for_file: avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../firebase_setup.dart';
import '../screens/order_history_page.dart';

/// Dipanggil FCM saat aplikasi di background atau tertutup. Harus fungsi top-level.
/// Pesan yang membawa blok notification sudah ditampilkan sistem, jadi cukup dicatat.
@pragma('vm:entry-point')
Future<void> handlerPesanLatar(RemoteMessage pesan) async {
  print('FCM background id=${pesan.messageId} judul=${pesan.notification?.title}');
}

class NotifikasiService {
  NotifikasiService._();
  static final NotifikasiService instance = NotifikasiService._();

  static const AndroidNotificationChannel _kanal = AndroidNotificationChannel(
    'status_pesanan',
    'Status Pesanan',
    description: 'Pemberitahuan perubahan status pesanan TokoKita',
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin _lokal = FlutterLocalNotificationsPlugin();
  final List<StreamSubscription<dynamic>> _langganan = [];
  bool _siap = false;
  bool _fcmJalan = false;
  int _idBerikut = 0;

  // FCM butuh project Firebase asli, jadi tidak dijalankan pada mode emulator.
  // Di web FCM juga butuh VAPID key dan service worker tersendiri, belum disiapkan.
  bool get fcmTersedia => !kIsWeb && !kPakaiEmulator;

  Future<void> siapkan() async {
    if (_siap) return;
    await _lokal.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
        web: WebInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (resp) => _bukaRiwayat(resp.payload),
    );
    await _lokal
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_kanal);
    _siap = true;
    print('Notifikasi lokal siap');
  }

  // Di web izin hanya diterima browser jika diminta dari aksi pengguna.
  Future<bool> mintaIzinLokal() async {
    await siapkan();
    final android = _lokal
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    final web = _lokal
        .resolvePlatformSpecificImplementation<WebFlutterLocalNotificationsPlugin>();
    bool? hasil = true;
    if (android != null) hasil = await android.requestNotificationsPermission();
    if (web != null) hasil = await web.requestNotificationsPermission();
    print('Izin notifikasi lokal diberikan=${hasil ?? false}');
    return hasil ?? false;
  }

  Future<void> tampilkan(String judul, String isi, {String payload = 'riwayat'}) async {
    await siapkan();
    await _lokal.show(
      id: _idBerikut++,
      title: judul,
      body: isi,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _kanal.id,
          _kanal.name,
          channelDescription: _kanal.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
        web: const WebNotificationDetails(),
      ),
      payload: payload,
    );
    print('Notifikasi lokal tampil judul=$judul');
  }

  // Pemicu uji tanpa FCM. Meniru langkah setelah pesan FCM diterima saat foreground.
  Future<bool> ujiLokal() async {
    final izin = await mintaIzinLokal();
    if (!izin) return false;
    await tampilkan('Pesanan Anda sedang diproses',
        'Pesanan Anda sedang disiapkan oleh penjual.');
    return true;
  }

  Future<void> mulaiFcm(String uid) async {
    if (!fcmTersedia) {
      print('FCM dilewati karena mode emulator atau web');
      return;
    }
    if (_fcmJalan) return;
    _fcmJalan = true;
    try {
      await siapkan();
      final fcm = FirebaseMessaging.instance;
      final izin = await fcm.requestPermission();
      print('FCM izin ${izin.authorizationStatus.name}');

      // getToken sudah ditandai deprecated di firebase_messaging 17, tetap dipakai
      // karena lembar praktikum memintanya. Penggantinya register() dan onRegistered.
      // ignore: deprecated_member_use
      final token = await fcm.getToken();
      if (token != null) await _simpanToken(uid, token);
      // ignore: deprecated_member_use
      _langganan.add(fcm.onTokenRefresh.listen((t) => _simpanToken(uid, t)));

      _langganan.add(FirebaseMessaging.onMessage.listen((pesan) {
        final n = pesan.notification;
        print('FCM foreground judul=${n?.title}');
        tampilkan(n?.title ?? 'TokoKita', n?.body ?? '',
            payload: pesan.data['orderId'] ?? 'riwayat');
      }));
      _langganan.add(FirebaseMessaging.onMessageOpenedApp.listen((_) {
        print('FCM dibuka dari background');
        _bukaRiwayat(null);
      }));

      final awal = await fcm.getInitialMessage();
      if (awal != null) {
        print('FCM membuka aplikasi dari kondisi tertutup');
        WidgetsBinding.instance.addPostFrameCallback((_) => _bukaRiwayat(null));
      }
    } catch (e) {
      _fcmJalan = false;
      print('FCM gagal dimulai $e');
    }
  }

  // Dipanggil sebelum logout supaya perangkat ini tidak menerima pesan milik akun lama.
  Future<void> berhenti(String uid) async {
    for (final l in _langganan) {
      await l.cancel();
    }
    _langganan.clear();
    if (!_fcmJalan) return;
    _fcmJalan = false;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'fcmToken': FieldValue.delete()});
      // ignore: deprecated_member_use
      await FirebaseMessaging.instance.deleteToken();
      print('FCM token dihapus untuk users/$uid');
    } catch (e) {
      print('FCM gagal menghapus token $e');
    }
  }

  Future<void> _simpanToken(String uid, String token) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'fcmToken': token,
      'tokenDiperbarui': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    print('FCM token ${token.substring(0, token.length < 10 ? token.length : 10)}... disimpan pada users/$uid');
  }

  void _bukaRiwayat(String? payload) {
    if (Get.find<AuthController>().user.value == null) return;
    print('Notifikasi ditekan payload=$payload, membuka Riwayat Pesanan');
    Get.to(() => const OrderHistoryPage());
  }
}
