import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/auth_controller.dart';
import 'controllers/cart_controller.dart';
import 'controllers/wishlist_controller.dart';
import 'firebase_setup.dart';
import 'models/product.dart';
import 'screens/login_page.dart';
import 'screens/main_page.dart';
import 'screens/product_detail_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  demoProductLogic();
  // ignore: avoid_print
  print('Aplikasi TokoKita dimulai dari main()');
  Get.put(CartController(), permanent: true);
  Get.put(WishlistController(), permanent: true);
  Get.put(AuthController(), permanent: true);
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
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      home: sudahMasuk ? const MainPage() : const LoginPage(),
      getPages: [
        GetPage(name: '/detail', page: () => ProductDetailPage(produk: Get.arguments as Product)),
      ],
    );
  }
}
