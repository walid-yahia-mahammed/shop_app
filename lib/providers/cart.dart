import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  int qty;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.qty,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) => total += cartItem.price * cartItem.qty);
    return total;
  }

  void deleteItem(productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.qty > 1) {
      _items[productId]!.qty = _items[productId]!.qty - 1;
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void addItem(
    String productId,
    String title,
    double price,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (value) => CartItem(
          id: value.id,
          title: value.title,
          qty: value.qty + 1,
          price: value.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          qty: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
