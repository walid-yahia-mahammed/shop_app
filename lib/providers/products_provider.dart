import 'dart:convert';
//packages
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//providers
import './product.dart';

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
    const url =
        'https://flutterproject-75f32-default-rtdb.europe-west1.firebasedatabase.app/products.json';
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
    const url =
        'https://flutterproject-75f32-default-rtdb.europe-west1.firebasedatabase.app/products.json';
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

  void updateProduct(String productid, productData) {
    int index = _items.indexWhere((element) => element.id == productid);
    _items[index] = Product(
      id: DateTime.now().toString(),
      title: productData['title'],
      description: productData['description'],
      price: productData['price'].toDouble(),
      imageUrl: productData['imageUrl'],
      isFavorite: _items[index].isFavorite,
    );
    notifyListeners();
  }

  void removeProduct(String productid) {
    _items.removeAt(_items.indexWhere((element) => element.id == productid));
    notifyListeners();
  }
}
