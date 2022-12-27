import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

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
  List<OrderItem> myOrders = [];
  String? authToken;
  String? userId;

  Orders(
    this.authToken,
    this.userId,
    this.myOrders,
  );

  List<OrderItem> get orders {
    return [...myOrders];
  }

  Future<void> fetchAnsSetOrders() async {
    /*
    final url = Uri.https(
      'flutter-update-31f2a-default-rtdb.firebaseio.com',
      '/orders.json/$userId?auth=${authToken}',
    );
    */

    const authority = "flutter-update-31f2a-default-rtdb.firebaseio.com";
    final path = "/orders/$userId.json";
    final params = {
      'auth': authToken,
    };
    final url = Uri.https(authority, path, params);
    final response = await http.get(url);
    print(json.decode(response.body));
    final List<OrderItem> loadedOrders = [];
    final extractedOrders = json.decode(response.body) as Map<String, dynamic>;
    extractedOrders.forEach(
      (orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            products: (orderData['products'] as List<dynamic>)
                .map(
                  ((e) => CartItem(
                        id: e['name'],
                        title: e['title'],
                        quantity: e['quantity'],
                        price: e['price'],
                      )),
                )
                .toList(),
            dateTime: DateTime.parse(orderData['dateTime']),
          ),
        );
      },
    );

    myOrders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const _authority = "flutter-update-31f2a-default-rtdb.firebaseio.com";
    final path = "/orders/$userId.json";
    final params = {
      'auth': authToken,
    };
    final url = Uri.https(_authority, path, params);

    final timestamp = DateTime.now();

    final response = await http.post(
      url,
      body: json.encode(
        {
          'amount': total,
          'products': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price,
                  })
              .toList(),
          'dateTime': timestamp.toIso8601String(),
        },
      ),
    );

    myOrders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timestamp,
      ),
    );
    notifyListeners();
  }
}
