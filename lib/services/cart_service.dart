import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/constants.dart';

import '../models/cart/cart.dart';
import 'protected_service.dart';

class CartService extends ProtectedService {
  // Constructor for CartService
  // @param authToken the user's authentication token
  // @param userId the ID of the user
  CartService(String authToken, String userId) : super(authToken, userId);
  // Gets the user's cart from the Firebase Realtime Database
  // @require _authToken and _userId are not null
  // @ensure returns the user's cart if the request is successful, or throws an error if the request fails
  Future<Cart> getCart() async {
    final _params = {
      'auth': authToken,
    };
    final url = Uri.https(baseUrl, '/carts/$userId.json', _params);
    final response = await http.get(url);

    if (response.body == 'null') {
      return Cart();
    }

    if (response.statusCode == 200) {
      //final Map<String, dynamic> data = await compute(parseCart, response.body);
      final data = json.decode(response.body) as Map<String, dynamic>;
      return Cart.fromJson(data);
    } else {
      throw Exception('Failed to get cart');
    }
  }

  // Updates the user's cart in the Firebase Realtime Database
  // @param cart the updated Cart object
  // @require _authToken and _userId are not null
  // @ensure updates the user's cart if the request is successful, or throws an error if the request fails
  Future<void> updateCart(Cart cart) async {
    final _params = {
      'auth': authToken,
    };
    final url = Uri.https(baseUrl, '/carts/$userId.json', _params);
    final response = await http.put(
      url,
      body: json.encode(cart.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update cart');
    }
  }
}
