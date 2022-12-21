import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  //it's not final, because it can be changable after the product is created
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    //OPTIMISTIC UPDATE
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final _authority = "flutter-update-31f2a-default-rtdb.firebaseio.com";
    final _path = "/userFavorites/$userId/$id.json";
    final _params = {
      'auth': token,
    };
    final url = Uri.https(_authority, _path, _params);

    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );

      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }
}
