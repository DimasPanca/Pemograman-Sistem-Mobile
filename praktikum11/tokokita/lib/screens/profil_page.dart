import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../services/notifikasi_service.dart';
import 'login_page.dart';
import 'order_history_page.dart';
import 'wishlist_page.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: skema.surface,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: skema.shadow.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: skema.primaryContainer,
                  child: Icon(Icons.person,
                      size: 34, color: skema.onPrimaryContainer),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dimas Panca Pamungkas',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Obx(() => Text(
                            Get.find<AuthController>().user.value?.email ??
                                'Belum masuk',
                            style: TextStyle(
                                fontSize: 13, color: skema.onSurfaceVariant),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _MenuItem(
            icon: Icons.history,
            label: 'Riwayat Pesanan',
            onTap: () => Get.to(() => const OrderHistoryPage()),
          ),
          _MenuItem(
            icon: Icons.favorite_outline,
            label: 'Produk Favorit',
            onTap: () => Get.to(() => const WishlistPage()),
          ),
          _MenuItem(
            icon: Icons.notifications_active_outlined,
            label: 'Uji Notifikasi Lokal',
            onTap: _ujiNotifikasi,
          ),
          const _MenuItem(icon: Icons.location_on_outlined, label: 'Alamat Pengiriman'),
          const _MenuItem(icon: Icons.help_outline, label: 'Bantuan'),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () async {
              await Get.find<AuthController>().keluar();
              Get.offAll(() => const LoginPage());
            },
            icon: const Icon(Icons.logout),
            label: const Text('Keluar'),
            style: OutlinedButton.styleFrom(
              foregroundColor: skema.error,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Menu Alamat Pengiriman dan Bantuan masih berupa pratinjau.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: skema.outline),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _ujiNotifikasi() async {
  final tampil = await NotifikasiService.instance.ujiLokal();
  if (!tampil) {
    Get.snackbar('Izin notifikasi ditolak',
        'Aktifkan izin notifikasi pada pengaturan browser atau perangkat.');
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _MenuItem({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: skema.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: skema.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500)),
          ),
          Icon(Icons.chevron_right, color: skema.outline),
        ],
      ),
      ),
    );
  }
}
