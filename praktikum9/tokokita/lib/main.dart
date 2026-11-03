import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/cart_controller.dart';
import 'controllers/order_controller.dart';
import 'controllers/wishlist_controller.dart';
import 'database/db_factory.dart';
import 'models/product.dart';
import 'screens/main_page.dart';
import 'screens/product_detail_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDatabaseFactory();
  demoProductLogic();
  // ignore: avoid_print
  print('Aplikasi TokoKita dimulai dari main()');
  Get.put(CartController(), permanent: true);
  Get.put(WishlistController(), permanent: true);
  Get.put(OrderController(), permanent: true);
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
