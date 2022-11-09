import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../secret/config.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void togleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
    final url = '${Config.base_url}/products/$id.json';
    try {
      http.patch(
        Uri.parse(url),
        body: json.encode({
          'isFavorite': isFavorite,
        }),
      );
    } catch (error) {
      isFavorite = !isFavorite;
      notifyListeners();
      throw error;
    }
  }
}
