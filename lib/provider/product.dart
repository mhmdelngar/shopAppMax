import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final double price;
  final String imageUrl;
  final String title;
  final String description;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.price,
      @required this.imageUrl,
      @required this.title,
      @required this.description,
      this.isFavorite = false});

  togle(bool oldValue) {
    isFavorite = oldValue;
    notifyListeners();
  }

  Future<void> favoriteChange(String authToken, String userId) async {
    bool currentState = isFavorite;
    isFavorite = !isFavorite;

    notifyListeners();
    try {
      final url =
          'https://api-request-ae8af.firebaseio.com/favorites/$userId/$id.json?auth=$authToken';
      final response = await http.put(url, body: jsonEncode(isFavorite));
      notifyListeners();
      if (response.statusCode >= 400) {
        togle(currentState);
      }
    } catch (error) {
      togle(currentState);
    }
  }
}
