# Pemrograman Sistem Mobile

Repositori kumpulan tugas praktikum mata kuliah Pemrograman Mobile.

- **Nama** Dimas Panca Pamungkas
- **NIM** 3337240063

## Struktur

Setiap pertemuan dipisah dalam foldernya masing-masing. Kode aplikasi `tokokita` di setiap folder adalah snapshot state proyek sesuai pertemuan itu, sehingga bisa dibuka langsung tanpa perlu berpindah branch.

| Folder | Topik | Isi |
| --- | --- | --- |
| [`praktikum1/`](praktikum1) | Pengantar Mobile Programming & Ekosistem Flutter/Dart | Proyek Flutter awal hasil `flutter create tokokita` beserta lembar praktikum dan laporan |
| [`praktikum2/`](praktikum2) | Dasar Dart | Penambahan `lib/models/product.dart`, `bin/tokokita_cli.dart`, dan versi awal ProductCard |
| [`praktikum3/`](praktikum3) | Widget Dasar Stateless vs Stateful | Pemisahan widget ke `lib/widgets/product_card.dart` dengan StatefulWidget, PriceLabel, StockBadge, dan CategoryTag |
| [`praktikum4/`](praktikum4) | Layout & UI (Row, Column, Container, Stack, ListView) | HomePage dengan header Row, Container decoration + shadow di ProductCard, badge diskon dengan Stack + Positioned, dan ListView.builder |

## Cara Menjalankan Salah Satu Praktikum

```bash
cd praktikum3/tokokita
flutter pub get
flutter run -d chrome
```

Ganti `praktikum3` dengan folder pertemuan lain yang ingin dijalankan.

Untuk versi CLI pada Praktikum 2 dapat dijalankan dengan

```bash
cd praktikum2/tokokita
dart run bin/tokokita_cli.dart
```
