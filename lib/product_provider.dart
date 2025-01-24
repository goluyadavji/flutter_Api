import 'dart:convert';
import 'package:api_call2/product_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;


class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;
  final String baseUrl = 'https://fakestoreapi.com/products';

  Future<void> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      _products = data.map((item) => Product.fromJson(item)).toList();
      notifyListeners();
      Fluttertoast.showToast(
        msg: 'get Product all${response.statusCode}',
        backgroundColor: Colors.blue,
      );
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> addProduct(String title, double price) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: json.encode({
        'title': title,
        'price': price,
        'description': 'description',
        'image': 'https://via.placeholder.com/150',
        'category': 'electronics',
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      getProducts();
      Fluttertoast.showToast(
        msg: 'Product Add success${response.statusCode}',
        backgroundColor: Colors.orange,
      );
    } else {
      throw Exception('Failed to add product');
    }
  }

  Future<void> updateProduct(int id, String title, double price) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      body: json.encode({
        'title': title,
        'price': price,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      getProducts();
      Fluttertoast.showToast(
        msg: 'Product update${response.statusCode}',
        backgroundColor: Colors.orange,
      );
    } else {
      throw Exception('Failed to update product');
    }
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      getProducts();
      Fluttertoast.showToast(
        msg: 'Product delete${response.statusCode}',
        backgroundColor: Colors.red,
      );
    } else {
      throw Exception('Failed to delete product');
    }
  }
}
