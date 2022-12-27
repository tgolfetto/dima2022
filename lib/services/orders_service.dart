import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/exceptions/http_exception.dart';

import '../utils/constants.dart';

import '../models/orders/order_item.dart';

import '../models/cart/cart_item.dart';

class OrdersService {
  // The user's authentication token
  String? _authToken;
  // The ID of the user
  String? _userId;

  // Constructor for CartService
  // @param authToken the user's authentication token
  // @param userId the ID of the user
  OrdersService(this._authToken, this._userId);

  // Fetches a list of orders made by the user
  // @return a list of OrderItem objects
  // @throws HttpException if the request fails
  // @requires _authToken != null && _userId != null
  // @ensures returns a list of OrderItem objects
  Future<List<OrderItem>> fetchOrders() async {
    final _path = "/orders/${_userId}.json";
    final _params = {
      'auth': _authToken,
    };
    final url = Uri.https(baseUrl, _path, _params);
    try {
      final response = await http.get(url);
      //print(json.decode(response.body));
      final List<OrderItem> loadedOrders = [];
      if (response.body == 'null') {
        return loadedOrders;
      }
      final extractedOrders =
          json.decode(response.body) as Map<String, dynamic>;

      extractedOrders.forEach(
        (orderId, orderData) {
          loadedOrders.add(OrderItem.fromJson(orderId, orderData));
        },
      );
      return loadedOrders.reversed.toList();
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  // Adds a new order to the database
  // @param cartProducts a list of CartItem objects representing the items in the order
  // @param total the total cost of the order
  // @return the newly created OrderItem object
  // @throws HttpException if the request fails
  // @requires _authToken != null && _userId != null
  // @ensures returns the newly created OrderItem object
  Future<OrderItem> addOrder(List<CartItem> cartProducts, double total) async {
    final _path = "/orders/${_userId}.json";
    final _params = {
      'auth': _authToken,
    };
    final url = Uri.https(baseUrl, _path, _params);

    final timestamp = DateTime.now();

    var newOrder = OrderItem(
      amount: total,
      products: cartProducts,
      dateTime: timestamp,
    );
    final response = await http.post(
      url,
      body: json.encode(newOrder.toJson()),
    );

    newOrder.id = json.decode(response.body)['name'];
    return newOrder;
  }
}
