import 'dart:convert';
//packages
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

//providers
import './product.dart';
import '../secret/config.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  var showFavoriteOnly = false;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favorites {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future fetchAndSetProducts() async {
    const url = '${Config.base_url}/products.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedProducts =
          json.decode(response.body) as Map<String, dynamic>;
      List<Product> loadedProducts = [];
      extractedProducts.forEach((id, values) {
        loadedProducts.add(
          Product(
            id: id,
            title: values['title'],
            description: values['description'],
            price: values['price'],
            imageUrl: values['imageUrl'],
            isFavorite: values['isFavorite'],
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future addProduct(productData) async {
    const url = '${Config.base_url}/products.json';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': productData['title'],
          'description': productData['description'],
          'price': productData['price'],
          'imageUrl': productData['imageUrl'],
          'isFavorite': false,
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: productData['title'],
        description: productData['description'],
        price: productData['price'],
        imageUrl: productData['imageUrl'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future updateProduct(String productid, productData) async {
    int index = _items.indexWhere((element) => element.id == productid);
    if (index >= 0) {
      final url = '${Config.base_url}/products/$productid.json';
      try {
        await http.patch(
          Uri.parse(url),
          body: json.encode({
            'title': productData['title'],
            'description': productData['description'],
            'price': productData['price'],
            'imageUrl': productData['imageUrl'],
          }),
        );
        _items[index] = Product(
          id: _items[index].id,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'].toDouble(),
          imageUrl: productData['imageUrl'],
          isFavorite: _items[index].isFavorite,
        );
        notifyListeners();
      } catch (error) {
        print(error);
        throw error;
      }
    }
  }

  Future<void> removeProduct(String productid) async {
    final url = '${Config.base_url}/products/$productid.json';
    final index = _items.indexWhere((element) => element.id == productid);
    Product? deletedProduct = _items[index];
    _items.removeAt(index);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.add(deletedProduct);
      notifyListeners();
      throw HttpException("did not delete");
    }
    deletedProduct = null;
  }
}
