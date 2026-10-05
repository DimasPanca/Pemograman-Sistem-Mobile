import 'package:flutter/material.dart';

import 'home_page.dart';
import 'keranjang_page.dart';
import 'profil_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int indexAktif = 0;

  final List<Widget> _halaman = const [
    HomePage(),
    KeranjangPage(),
    ProfilPage(),
  ];

  void _pindahTab(int index) {
    setState(() => indexAktif = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: indexAktif,
        children: _halaman,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexAktif,
        onTap: _pindahTab,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.black45,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Keranjang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
