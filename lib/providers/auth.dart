import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

import '../secret/config.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expirytime;
  String? _userId;

  bool get isAuth {
    return token != '';
  }

  String get token {
    if (_expirytime != null && _expirytime!.isAfter(DateTime.now())) {
      return _token as String;
    }
    return '';
  }
  String get userId {
      return _userId as String;
  }

  Future _authenticate(String email, String password, String url) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expirytime = DateTime.now().add(Duration(
        seconds: int.parse(responseData['expiresIn']),
      ));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> singup(String email, String password) async {
    return _authenticate(email, password, Config.singup_url);
  }

  Future<void> singin(String email, String password) async {
    return _authenticate(email, password, Config.singin_url);
  }
}
