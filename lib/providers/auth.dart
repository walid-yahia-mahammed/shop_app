import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';

import '../secret/config.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expirytime;
  String? _userId;
  Timer? _autoTimer;

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
      autoLogOut();
      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token!,
        'userId': _userId!,
        'expiryDate': _expirytime?.toIso8601String(),
      });
      pref.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData') as String)
        as Map<String, Object>;
    final expairyDate =
        DateTime.parse(extractedUserData['expiryDate'] as String);

    if (expairyDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'] as String;
    _userId = extractedUserData['userId'] as String;
    _expirytime = expairyDate;
    notifyListeners();
    autoLogOut();
    return true;
  }

  Future<void> singup(String email, String password) async {
    return _authenticate(email, password, Config.singup_url);
  }

  Future<void> singin(String email, String password) async {
    return _authenticate(email, password, Config.singin_url);
  }

  Future<void> logOut() async {
    _token = '';
    _userId = '';
    _expirytime = null;
    if (_autoTimer != null) {
      _autoTimer?.cancel();
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  void autoLogOut() {
    if (_autoTimer != null) {
      _autoTimer?.cancel();
    }
    final timeToExpiry = _expirytime!.difference(DateTime.now()).inSeconds;
    _autoTimer = Timer(Duration(seconds: timeToExpiry), logOut);
  }
}
