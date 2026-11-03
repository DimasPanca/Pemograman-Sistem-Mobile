// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistController extends GetxController {
  static const String _kunci = 'wishlist_ids';

  final RxList<String> ids = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _muat();
  }

  Future<void> _muat() async {
    final prefs = await SharedPreferences.getInstance();
    ids.assignAll(prefs.getStringList(_kunci) ?? <String>[]);
    print('SharedPreferences load wishlist -> ${ids.toList()}');
  }

  bool isFavorite(String id) => ids.contains(id);

  Future<void> toggle(String id) async {
    if (ids.contains(id)) {
      ids.remove(id);
    } else {
      ids.add(id);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kunci, ids.toList());
    print('SharedPreferences simpan wishlist -> ${ids.toList()}');
  }
}
