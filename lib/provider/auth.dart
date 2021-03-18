import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app_state_manangement/models/http_exption.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _id;
  Timer _authTimer;
  String get id {
    return _id;
  }

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> authentication(
      String email, String password, String signType) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$signType?key=AIzaSyDgeV2AmaOmMxKzIZWq8OjzgRBprKghSSM';
    try {
      final response = await http.post(
        '$url ',
        body: jsonEncode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final responseCode = jsonDecode(response.body);
      if (responseCode['error'] != null) {
        print(responseCode['error']['message']);
        throw HttpException(responseCode['error']['message']);
      }
      _token = responseCode['idToken'];
      _id = responseCode['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseCode['expiresIn'])));

      // isAuth;
      // print(isAuth);
      autoLogOut();
      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      final userData = jsonEncode({
        'token': _token,
        'userId': _id,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      pref.setString('userData', userData);
    } catch (e) {
      throw e;
    }
  }

  Future<void> signUp(String email, String password) async {
    return authentication(email, password, 'signUp');
  }

  Future<bool> tryLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final prefDate =
        jsonDecode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(prefDate['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = prefDate['token'];
    _id = prefDate['userId'];
    _expiryDate = expiryDate;

    autoLogOut();
    notifyListeners();
    return true;
  }

  Future<void> signIn(String email, String password) async {
    return authentication(email, password, 'signInWithPassword');
  }

  Future<void> logOut() async {
    _id = null;
    _token = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  void autoLogOut() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    var expierd = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: expierd), logOut);
  }
}
