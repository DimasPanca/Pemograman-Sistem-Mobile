import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:get/get.dart';

import 'controllers/auth_controller.dart';
import 'controllers/cart_controller.dart';
import 'controllers/lokasi_controller.dart';
import 'controllers/profil_controller.dart';
import 'controllers/wishlist_controller.dart';
import 'firebase_setup.dart';
import 'models/product.dart';
import 'screens/login_page.dart';
import 'screens/main_page.dart';
import 'screens/product_detail_page.dart';
import 'services/notifikasi_service.dart';
import 'theme/app_theme.dart';

// Memperlambat semua animasi supaya mudah diamati, contoh --dart-define=PERLAMBAT=4
const int _perlambat = int.fromEnvironment('PERLAMBAT', defaultValue: 1);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  timeDilation = _perlambat.toDouble();
  await initFirebase();
  if (NotifikasiService.instance.fcmTersedia) {
    FirebaseMessaging.onBackgroundMessage(handlerPesanLatar);
  }
  demoProductLogic();
  // ignore: avoid_print
  print('Aplikasi TokoKita dimulai dari main()');
  Get.put(CartController(), permanent: true);
  Get.put(WishlistController(), permanent: true);
  Get.put(AuthController(), permanent: true);
  Get.put(ProfilController(), permanent: true);
  Get.put(LokasiController(), permanent: true);
  runApp(MyApp(sudahMasuk: FirebaseAuth.instance.currentUser != null));
}

class MyApp extends StatelessWidget {
  final bool sudahMasuk;

  const MyApp({super.key, required this.sudahMasuk});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TokoKita',
      debugShowCheckedModeBanner: false,
      theme: buatTema(),
      home: sudahMasuk ? const MainPage() : const LoginPage(),
      // Di web, refresh pada halaman hasil Get.to membawa nama rute yang tidak terdaftar.
      unknownRoute: GetPage(
        name: '/tidak-ditemukan',
        page: () => sudahMasuk ? const MainPage() : const LoginPage(),
      ),
      getPages: [
        GetPage(name: '/detail', page: () => ProductDetailPage(produk: Get.arguments as Product)),
      ],
    );
  }
}
