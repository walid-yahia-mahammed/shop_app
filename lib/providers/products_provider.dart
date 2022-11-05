import 'dart:convert';
//packages
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//providers
import './product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

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
