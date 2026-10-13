import 'package:flutter/material.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(Icons.person,
                      size: 34, color: Colors.blue.shade800),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dimas Panca Pamungkas',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'NIM 3337240063',
                        style: TextStyle(
                            fontSize: 13, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const _MenuItem(icon: Icons.history, label: 'Riwayat Pesanan'),
          const _MenuItem(icon: Icons.favorite_outline, label: 'Produk Favorit'),
          const _MenuItem(icon: Icons.location_on_outlined, label: 'Alamat Pengiriman'),
          const _MenuItem(icon: Icons.help_outline, label: 'Bantuan'),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Menu di atas masih berupa pratinjau dan akan diaktifkan pada pertemuan berikutnya.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black45),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MenuItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade700, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500)),
          ),
          const Icon(Icons.chevron_right, color: Colors.black38),
        ],
      ),
    );
  }
}
