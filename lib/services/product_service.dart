import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/constants.dart';

import '../models/product/product.dart';

class ProductService {
  // The user's authentication token
  static String? authToken;
  // The ID of the user
  static String? userId;

  // Toggles the favorite status of a product for the current user
  // @param _product the Product object to update the favorite status for
  // @return true if the operation was successful, false otherwise
  // @requires authToken != null && userId != null
  // @ensures returns true if the operation was successful, false otherwise
  Future<bool> toggleFavoriteStatus(Product _product) async {
    final _path = "/userFavorites/$userId/${_product.id}.json";
    final _params = {
      'auth': authToken,
    };
    final url = Uri.https(baseUrl, _path, _params);

    try {
      final response = await http.put(
        url,
        body: json.encode(
          _product.isFavorite,
        ),
      );

      if (response.statusCode >= 400) {
        return false;
      }
      return true;
    } catch (error) {
      return false;
    }
  }
}
