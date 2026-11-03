import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/cart_controller.dart';
import 'models/product.dart';
import 'screens/main_page.dart';
import 'screens/product_detail_page.dart';

void main() {
  demoProductLogic();
  // ignore: avoid_print
  print('Aplikasi TokoKita dimulai dari main()');
  Get.put(CartController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TokoKita',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const MainPage()),
        GetPage(name: '/detail', page: () => ProductDetailPage(produk: Get.arguments as Product)),
      ],
    );
  }
}
