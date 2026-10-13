// ignore_for_file: avoid_print

import 'dart:io';

import 'package:tokokita/models/product.dart';

String bacaInput(String pesan) {
  stdout.write(pesan);
  return stdin.readLineSync()?.trim() ?? '';
}

int bacaAngka(String pesan, {int nilaiDefault = 0}) {
  final input = bacaInput(pesan);
  return int.tryParse(input) ?? nilaiDefault;
}

double bacaHarga(String pesan, {double nilaiDefault = 0}) {
  final input = bacaInput(pesan);
  return double.tryParse(input) ?? nilaiDefault;
}

void tampilkanProduk(List<Product> produk) {
  if (produk.isEmpty) {
    print('Belum ada produk.');
    return;
  }

  print('Daftar produk');
  for (final item in produk) {
    print(
      '${item.id} | ${item.name} | ${formatRupiah(item.price)} | '
      '${item.category} | stok ${item.stock} | ${item.getStatusStok()}',
    );
  }
}

String buatIdBaru(List<Product> produk) {
  var nomor = produk.length + 1;
  var id = 'P${nomor.toString().padLeft(3, '0')}';
  while (produk.any((item) => item.id == id)) {
    nomor++;
    id = 'P${nomor.toString().padLeft(3, '0')}';
  }
  return id;
}

void tambahProduk(List<Product> produk) {
  final idInput = bacaInput('ID produk, Enter untuk otomatis: ');
  final id = idInput.isEmpty ? buatIdBaru(produk) : idInput;
  final name = bacaInput('Nama produk: ');
  final price = bacaHarga('Harga: ');
  final category = bacaInput('Kategori: ');
  final stock = bacaAngka('Stok: ');
  final descriptionInput = bacaInput('Deskripsi, boleh dikosongkan: ');

  produk.add(
    Product(
      id: id,
      name: name,
      price: price,
      imageUrl: '',
      category: category,
      stock: stock,
      description: descriptionInput.isEmpty ? null : descriptionInput,
    ),
  );
  print('Produk berhasil ditambahkan dengan ID $id.');
}

void ubahProduk(List<Product> produk) {
  final id = bacaInput('Masukkan ID produk yang akan diubah: ');
  final index = produk.indexWhere((item) => item.id == id);
  if (index == -1) {
    print('Produk tidak ditemukan.');
    return;
  }

  final lama = produk[index];
  final nameInput = bacaInput('Nama baru, Enter untuk tetap: ');
  final priceInput = bacaInput('Harga baru, Enter untuk tetap: ');
  final categoryInput = bacaInput('Kategori baru, Enter untuk tetap: ');
  final stockInput = bacaInput('Stok baru, Enter untuk tetap: ');
  final descriptionInput = bacaInput(
    'Deskripsi baru, Enter untuk tetap atau - untuk mengosongkan: ',
  );

  produk[index] = Product(
    id: lama.id,
    name: nameInput.isEmpty ? lama.name : nameInput,
    price: double.tryParse(priceInput) ?? lama.price,
    imageUrl: lama.imageUrl,
    category: categoryInput.isEmpty ? lama.category : categoryInput,
    stock: int.tryParse(stockInput) ?? lama.stock,
    description: descriptionInput == '-'
        ? null
        : descriptionInput.isEmpty
        ? lama.description
        : descriptionInput,
  );
  print('Produk berhasil diubah.');
}

void hapusProduk(List<Product> produk) {
  final id = bacaInput('Masukkan ID produk yang akan dihapus: ');
  final jumlahSebelum = produk.length;
  produk.removeWhere((item) => item.id == id);
  if (produk.length == jumlahSebelum) {
    print('Produk tidak ditemukan.');
    return;
  }
  print('Produk berhasil dihapus.');
}

void tampilkanTotalBelanja(List<Product> produk) {
  final total = hitungTotalBelanja(produk);
  print('Total belanja dari daftar saat ini: ${formatRupiah(total)}');
}

void cobaDiskon() {
  final category = bacaInput('Masukkan kategori produk: ');
  final discount = diskonKategori(category);
  print('Diskon untuk $category adalah ${discount.toStringAsFixed(0)} persen.');
}

void tampilkanMenu() {
  print('');
  print('Menu TokoKita');
  print('1. Lihat semua produk');
  print('2. Tambah produk');
  print('3. Ubah produk');
  print('4. Hapus produk');
  print('5. Hitung total belanja');
  print('6. Cek diskon kategori');
  print('0. Keluar');
}

void main() {
  final produk = List<Product>.from(daftarProduk);
  var berjalan = true;

  print('CLI TokoKita');
  while (berjalan) {
    tampilkanMenu();
    final pilihan = bacaInput('Pilih menu: ');
    print('');

    switch (pilihan) {
      case '1':
        tampilkanProduk(produk);
      case '2':
        tambahProduk(produk);
      case '3':
        ubahProduk(produk);
      case '4':
        hapusProduk(produk);
      case '5':
        tampilkanTotalBelanja(produk);
      case '6':
        cobaDiskon();
      case '0':
        berjalan = false;
        print('Program selesai.');
      default:
        print('Menu tidak tersedia.');
    }
  }
}
