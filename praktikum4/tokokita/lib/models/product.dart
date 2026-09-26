// ignore_for_file: avoid_print

const String namaToko = 'TokoKita';

const List<String> kategoriProduk = ['Elektronik', 'Fashion', 'Makanan'];

const Map<String, dynamic> dataMentahProduk = {
  'id': 'P001',
  'name': 'Smartphone Entry',
  'price': 4500000,
  'stock': 4,
};

class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  final int stock;
  final String? description;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.stock,
    this.description,
  });

  String getStatusStok() {
    if (stock <= 0) {
      return 'Habis';
    } else if (stock <= 3) {
      return 'Stok Terbatas';
    }
    return 'Tersedia';
  }
}

class DiscountedProduct extends Product {
  final double discountPercent;

  const DiscountedProduct({
    required super.id,
    required super.name,
    required super.price,
    required super.imageUrl,
    required super.category,
    required super.stock,
    super.description,
    required this.discountPercent,
  });

  double getHargaFinal() {
    return hitungHargaSetelahDiskon(price, persenDiskon: discountPercent);
  }
}

double hitungHargaSetelahDiskon(double harga, {double persenDiskon = 0}) {
  final potongan = harga * persenDiskon / 100;
  return harga - potongan;
}

String formatRupiah(double harga) => 'Rp ${harga.toStringAsFixed(0)}';

double hitungTotalBelanja(List<Product> keranjang) {
  var total = 0.0;
  for (final produk in keranjang) {
    total += produk.price;
  }
  return total;
}

double hitungTotalHarga(List<double> daftarHarga) {
  var total = 0.0;
  for (final harga in daftarHarga) {
    total += harga;
  }
  return total;
}

int hitungSisaStok(int stokAwal, int jumlahPembelian) {
  var sisaStok = stokAwal;
  var jumlahDiproses = jumlahPembelian;

  while (jumlahDiproses > 0 && sisaStok > 0) {
    sisaStok--;
    jumlahDiproses--;
  }
  return sisaStok;
}

double diskonKategori(String kategori) {
  switch (kategori) {
    case 'Elektronik':
      return 10;
    case 'Fashion':
      return 15;
    case 'Makanan':
      return 5;
    default:
      return 0;
  }
}

final List<Product> daftarProduk = [
  const Product(
    id: 'P001',
    name: 'Smartphone Entry',
    price: 4500000,
    imageUrl: '',
    category: 'Elektronik',
    stock: 4,
    description: 'Ponsel untuk kebutuhan sehari-hari.',
  ),
  const Product(
    id: 'P002',
    name: 'Earbuds Bluetooth',
    price: 350000,
    imageUrl: '',
    category: 'Elektronik',
    stock: 12,
  ),
  const Product(
    id: 'P003',
    name: 'Keyboard Wireless',
    price: 275000,
    imageUrl: '',
    category: 'Elektronik',
    stock: 2,
  ),
  const Product(
    id: 'P004',
    name: 'Hoodie Polos',
    price: 250000,
    imageUrl: '',
    category: 'Fashion',
    stock: 8,
  ),
  const Product(
    id: 'P005',
    name: 'Celana Jeans',
    price: 300000,
    imageUrl: '',
    category: 'Fashion',
    stock: 0,
  ),
  const Product(
    id: 'P006',
    name: 'Kopi Arabika',
    price: 85000,
    imageUrl: '',
    category: 'Makanan',
    stock: 10,
  ),
  const Product(
    id: 'P007',
    name: 'Mouse Wireless',
    price: 150000,
    imageUrl: '',
    category: 'Elektronik',
    stock: 5,
  ),
  const Product(
    id: 'P008',
    name: 'Powerbank 10000mAh',
    price: 220000,
    imageUrl: '',
    category: 'Elektronik',
    stock: 3,
  ),
  const Product(
    id: 'P009',
    name: 'Kaos Katun',
    price: 95000,
    imageUrl: '',
    category: 'Fashion',
    stock: 20,
    description: 'Bahan katun combed 30s adem dipakai.',
  ),
  const DiscountedProduct(
    id: 'P010',
    name: 'Speaker Mini',
    price: 200000,
    imageUrl: '',
    category: 'Elektronik',
    stock: 6,
    discountPercent: 10,
    description: 'Speaker bluetooth ringkas untuk meja kerja.',
  ),
  const Product(
    id: 'P011',
    name: 'Cokelat Batang',
    price: 45000,
    imageUrl: '',
    category: 'Makanan',
    stock: 25,
  ),
  const DiscountedProduct(
    id: 'P012',
    name: 'Jaket Bomber',
    price: 375000,
    imageUrl: '',
    category: 'Fashion',
    stock: 4,
    discountPercent: 15,
  ),
  const Product(
    id: 'P013',
    name: 'Teh Celup Premium',
    price: 35000,
    imageUrl: '',
    category: 'Makanan',
    stock: 18,
    description: 'Teh hitam pilihan isi 25 kantung.',
  ),
  const DiscountedProduct(
    id: 'P014',
    name: 'Smartwatch Sport',
    price: 850000,
    imageUrl: '',
    category: 'Elektronik',
    stock: 7,
    discountPercent: 10,
  ),
  const Product(
    id: 'P015',
    name: 'Kacamata Anti Radiasi',
    price: 180000,
    imageUrl: '',
    category: 'Fashion',
    stock: 9,
  ),
  const Product(
    id: 'P016',
    name: 'Keripik Singkong',
    price: 22000,
    imageUrl: '',
    category: 'Makanan',
    stock: 0,
  ),
  const DiscountedProduct(
    id: 'P017',
    name: 'Charger Fast 45W',
    price: 165000,
    imageUrl: '',
    category: 'Elektronik',
    stock: 11,
    discountPercent: 10,
    description: 'Charger USB-C mendukung PD dan QC 4.',
  ),
];

void demoProductLogic() {
  var stok = 12;
  final harga = 125000.0;
  const produkAktif = true;
  final layakDitampilkan = produkAktif && stok > 0 && harga > 0;
  final totalHarga = hitungTotalHarga([harga, 75000, 50000]);
  final sisaStok = hitungSisaStok(stok, 5);
  final diskonElektronik = diskonKategori('Elektronik');
  final produkDiskon = DiscountedProduct(
    id: 'D001',
    name: 'Speaker Mini',
    price: 200000,
    imageUrl: '',
    category: 'Elektronik',
    stock: 6,
    discountPercent: diskonElektronik,
  );

  print('Nama toko: $namaToko');
  print('Kategori: $kategoriProduk');
  print('Data mentah: $dataMentahProduk');
  print('Produk layak ditampilkan: $layakDitampilkan');
  print('Total harga contoh: ${formatRupiah(totalHarga)}');
  print('Sisa stok setelah pembelian: $sisaStok');
  print('Harga setelah diskon: ${formatRupiah(produkDiskon.getHargaFinal())}');
}
