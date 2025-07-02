import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:full_crud_app/models/products.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  final String apiUrl = 'http://10.0.2.2:3000/products';
  List<Product> _items = [];
  List<Product> get items => _items;
  List<Product> _filteredItems = [];
  List<Product> get filteredItems =>
      _filteredItems.isNotEmpty ? _filteredItems : _items;
  bool isLoading = false;
  Timer? _debounce;
  int _offset = 0;
  final int _limit = 10;
  bool hasMore = true;

  Future<void> loadMore() async {
    if (!hasMore || isLoading) return;

    isLoading = true;
    notifyListeners();

    final res = await http.get(
      Uri.parse('$apiUrl?offset=$_offset&limit=$_limit'),
    );

    if (res.statusCode == 200) {
      final newData =
          (json.decode(res.body) as List)
              .map((e) => Product.fromJson(e))
              .toList();

      if (newData.isEmpty || newData.length < _limit) {
        hasMore = false;
      }
      for (var product in newData) {
        if (!_filteredItems.any((item) => item.id == product.id)) {
          _filteredItems.add(product);
        }
      }
      _offset += _limit;
    } else {
      hasMore = false;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    isLoading = true;
    notifyListeners();
    final res = await http.get(Uri.parse(apiUrl));
    _items =
        (json.decode(res.body) as List)
            .map((e) => Product.fromJson(e))
            .toList();
    isLoading = false;
    notifyListeners();
  }

  void filterProductsByName(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (query.isEmpty) {
        _filteredItems = [];
      } else {
        _filteredItems =
            _items
                .where(
                  (product) =>
                      product.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      }
      notifyListeners();
    });
  }

  void setProducts(List<Product> products) {
    _items = products;
    _items = [];
    notifyListeners();
  }

  Future<void> addProduct(Product p) async {
    final res = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(p.toJson()),
    );
    if (res.statusCode == 201) {
      await fetchProducts();
    }
  }

  Future<void> updateProduct(Product p) async {
    final res = await http.put(
      Uri.parse('$apiUrl?id=${p.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': p.id, ...p.toJson()}),
    );
    if (res.statusCode == 200) {
      await fetchProducts();
    }
  }

  Future<void> deleteProduct(int id) async {
    final res = await http.delete(Uri.parse('$apiUrl?id=$id'));
    if (res.statusCode == 200) {
      _items.removeWhere((p) => p.id == id);
      notifyListeners();
    }
  }

  void sortProductsByPriceAscending() {
    _items.sort((a, b) => a.price.compareTo(b.price));
    notifyListeners();
  }

  void sortProductsByPriceDescending() {
    _items.sort((a, b) => b.price.compareTo(a.price));
    notifyListeners();
  }

  void sortProductsByStockAscending() {
    _items.sort((a, b) => a.stock.compareTo(b.stock));
    notifyListeners();
  }

  void sortProductsByStockDescending() {
    _items.sort((a, b) => b.stock.compareTo(a.stock));
    notifyListeners();
  }
}