// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductService {
  static const String _baseUrl = 'https://fakestoreapi.com';

  Future<List<Product>> fetchProducts() async {
    final url = Uri.parse('$_baseUrl/products');
    try {
      final response = await http.get(url);
      print('GET $url -> ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception('Server mengembalikan status ${response.statusCode}');
      }

      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('fetchProducts error: $e');
      rethrow;
    }
  }

  Future<Product> fetchProductDetail(int id) async {
    final url = Uri.parse('$_baseUrl/products/$id');
    try {
      final response = await http.get(url);
      print('GET $url -> ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception('Server mengembalikan status ${response.statusCode}');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Product.fromJson(json);
    } catch (e) {
      print('fetchProductDetail error: $e');
      rethrow;
    }
  }
}
