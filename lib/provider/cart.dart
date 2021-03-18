import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _item = {};
  Map<String, CartItem> get items {
    return {..._item};
  }

  int get getlength {
    return _item.length;
  }

  double get totalAmount {
    double total = 0.0;
    _item.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  addItem(String productId, String title, double price) {
    if (_item.containsKey(productId)) {
      _item.update(
          productId,
          (value) => CartItem(
              id: value.id,
              quantity: value.quantity + 1,
              price: value.price,
              title: value.title));
    } else {
      _item.putIfAbsent(
          productId,
          () => CartItem(
              title: title,
              id: DateTime.now().toString(),
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _item.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String prductId) {
    if (!_item.containsKey(prductId)) {
      return;
    }
    if (_item[prductId].quantity > 1) {
      _item.update(
          prductId,
          (value) => CartItem(
              id: value.id,
              quantity: value.quantity - 1,
              price: value.price,
              title: value.title));
    } else {
      _item.remove(prductId);
    }
    notifyListeners();
  }

  clearItems() {
    _item.clear();
    notifyListeners();
  }
}
