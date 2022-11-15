import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../secret/config.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expirytime;
  String? userId;

  Future<void> singup(String email, String password) async {
    const url = Config.singup_url;
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    print(json.decode(response.body));
  }
}
