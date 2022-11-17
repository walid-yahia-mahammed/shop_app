import 'dart:convert';
//packages
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//providers
import './cart.dart';
import '../secret/config.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  String authToken;
  String userId;

  List<OrderItem> get orders {
    return [..._orders];
  }

  Orders(this.authToken, this.userId, _orders);
  Future fetchAndSetOrders() async {
    final url = '${Config.base_url}/orders/$userId.json?auth=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedOrderItems = json.decode(response.body) ?? {};
      List<OrderItem> loadedOrderItems = [];
      if (extractedOrderItems.isNotEmpty) {
        extractedOrderItems.forEach((id, values) {
          loadedOrderItems.add(
            OrderItem(
              id: id,
              amount: values['amount'],
              products: (values['products'] as List<dynamic>)
                  .map((product) => CartItem(
                        id: product['id'],
                        title: product['title'],
                        qty: product['quantity'],
                        price: product['price'],
                      ))
                  .toList(),
              dateTime: DateTime.parse(values['dateTime']),
            ),
          );
        });
      }
      _orders = loadedOrderItems.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future addOrder(List<CartItem> cartProducts, double total) async {
    final url = '${Config.base_url}/orders/$userId.json?auth=$authToken';
    try {
      final timestamp = DateTime.now();
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.qty,
                    'price': cp.price,
                    'creatorId': userId,
                  })
              .toList(),
        }),
      );
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timestamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }
}
