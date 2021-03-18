import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app_state_manangement/models/http_exption.dart';

import '../provider/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  final String authToken;
  final String userId;

  Products(this.authToken, this._items, this.userId);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    String filter = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://api-request-ae8af.firebaseio.com/products.json?auth=$authToken&$filter';
    try {
      final response = await http.get(url);
      print(jsonDecode(response.body).toString());
      final List<Product> loadedData = [];
      final comingData = jsonDecode(response.body) as Map<String, dynamic>;
      if (comingData == null) {
        return;
      }

      url =
          'https://api-request-ae8af.firebaseio.com/favorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = jsonDecode(favoriteResponse.body);
      comingData.forEach((productId, product) {
        loadedData.add(Product(
            id: productId,
            imageUrl: product['imageUrl'],
            price: product['price'],
            title: product['title'],
            description: product['description'],
            isFavorite: favoriteData == null
                ? false
                : favoriteData['$productId'] ?? false));
      });
      _items = loadedData;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://api-request-ae8af.firebaseio.com/products.json?auth=$authToken';

    try {
      final response = await http.post(url,
          body: json.encode({
            'description': product.description,
            'title': product.title,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
          }));

      print(jsonDecode(response.body));
      _items.add(
        Product(
            description: product.description,
            id: jsonDecode(response.body)['name'],
            title: product.title,
            price: product.price,
            imageUrl: product.imageUrl),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product updatedProduct) async {
    final index = items.indexWhere((element) => element.id == id);
    final url =
        'https://api-request-ae8af.firebaseio.com/products/$id.json?auth=$authToken';
    await http.patch(url,
        body: json.encode({
          'description': updatedProduct.description,
          'title': updatedProduct.title,
          'price': updatedProduct.price,
          'imageUrl': updatedProduct.imageUrl,
        }));

    if (index >= 0) {
      print('------');
      _items[index] = updatedProduct;
      notifyListeners();
    } else {}
  }

  removeItems(String id) async {
    final url =
        'https://api-request-ae8af.firebaseio.com/products/$id.json?auth=$authToken';

    final indexOfTheItem = _items.indexWhere((element) => element.id == id);
    var wantToDelete = _items[indexOfTheItem];

    _items.removeAt(indexOfTheItem);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(indexOfTheItem, wantToDelete);
      notifyListeners();

      throw HttpException('wrong');
    }
  }
}
