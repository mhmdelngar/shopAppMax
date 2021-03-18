import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class OrderItem {
  final String id;
  final List<CartItem> product;

  OrderItem({this.id, this.product, this.date, this.amount});

  final DateTime date;
  final double amount;
}

class Order with ChangeNotifier {
  final String authToken;
  final String userId;

  List<OrderItem> _orders = [];

  Order(this.authToken, this._orders, this.userId);

  List<OrderItem> get orders {
    return [..._orders.toList()];
  }

  fetchData() async {
    final url =
        'https://api-request-ae8af.firebaseio.com/orders/$userId.json?auth=$authToken';

    final response = await http.get(url);
    print(jsonDecode(response.body));
    List<OrderItem> loadedData = [];
    final comingData = jsonDecode(response.body) as Map<String, dynamic>;
    if (comingData == null) {
      return;
    }
    comingData.forEach((key, value) {
      loadedData.add(OrderItem(
        id: key,
        amount: value['amount'],
        product: (value['product'] as List<dynamic>).map((e) {
          return CartItem(
            id: e['id'],
            price: e['price'],
            title: e['title'],
            quantity: e['quantity'],
          );
        }).toList(),
        date: DateTime.parse(value['date']),
      ));
      _orders = loadedData.reversed.toList();
      notifyListeners();
    });
  }

  Future<dynamic> addOrder(
      double total, DateTime date, List<CartItem> cartItem) async {
    List<Map<String, Object>> toRead = cartItem.map((element) {
      return {
        'quantity': element.quantity,
        'price': element.price,
        'title': element.title,
      };
    }).toList();

    try {
      final url =
          'https://api-request-ae8af.firebaseio.com/orders/$userId.json?auth=$authToken';
      final timeLapse = DateTime.now();
      final response = await http.post(url,
          body: json.encode({
            'date': timeLapse.toString(),
            'amount': total,
            'product': toRead,
            // 'product': [cartItem],
          }));

      print(jsonDecode(response.body));
      _orders.insert(
          0,
          OrderItem(
            id: jsonDecode(response.body)['name'],
            date: timeLapse,
            amount: total,
            product: cartItem,
          ));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
