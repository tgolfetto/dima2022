import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'http_exception.dart';

import 'product.dart';

class Products with ChangeNotifier {
  // it's not final, because it will change over times
  List<Product> _items = [];
  // [
  //   Product(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     description: 'A red shirt - it is pretty red!',
  //     price: 29.99,
  //     imageUrl:
  //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Trousers',
  //     description: 'A nice pair of trousers.',
  //     price: 59.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'Yellow Scarf',
  //     description: 'Warm and cozy - exactly what you need for the winter.',
  //     price: 19.99,
  //     imageUrl:
  //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'A Pan',
  //     description: 'Prepare any meal you want.',
  //     price: 49.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  //   ),
  // ];

  //var _showFavoriteOnly = false;

  // void showFavoriteOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }

  String? authToken;
  String? userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    // if (_showFavoriteOnly) {
    //   return _items.where((prodId) => prodId.isFavorite).toList();
    // }
    return [..._items];
    //i'm returning a copy of the original list, otherwise returning
    //directly _item i'm returning a pointer to that list getting direct access
    //to the list in memory, so we could edit the list from everywhere
    //(and i would do something similar but only for the listener)
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    Map<String, String> optionalParameters = filterByUser
        ? {
            "orderBy": "creatorId",
            "equalTo": userId!,
          }
        : {};

    final _authority = "flutter-update-31f2a-default-rtdb.firebaseio.com";
    final _path = "/products.json";
    final _params = optionalParameters;
    _params.addAll({
      'auth': authToken!,
    });

    final url = Uri.https(_authority, _path, _params);

    try {
      final response = await http.get(url);

      //For sure, we have to "decode" the response
      print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      final _pathFavorite = "/userFavorites/$userId.json";
      final _paramsFavorite = optionalParameters;
      _params.addAll({
        'auth': authToken!,
      });
      final urlFavorite = Uri.https(_authority, _pathFavorite, _paramsFavorite);

      final favoriteResponse = await http.get(urlFavorite);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];

      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            imageUrl: prodData['imageUrl'],
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    //first, let's update the DB
    /*
    final url = Uri.https(
      'flutter-update-31f2a-default-rtdb.firebaseio.com',
      '/products.json?auth=${authToken}',
    );
    */

    final _authority = "flutter-update-31f2a-default-rtdb.firebaseio.com";
    final _path = "/products.json";
    final _params = {
      'auth': authToken,
    };

    final url = Uri.https(_authority, _path, _params);

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
            //'isFavorite': product.isFavorite,
          },
        ),
      );

      //this is executed once the await finishes
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners(); //then the widgets ONLY that are listening will be re-built

    } catch (error) {
      print(error);
      throw error;
    }

    // print(error);
    // // we take the error --> and we generate another error,
    // //this because we don't want that this error goes on edit_products_screen
    // //but we want generate another exception, and catch this latter --> inside edit_products_screen
    // throw error;

    //N.B. post returns a Future response --> so it's asynch, it does not block the code following
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      /*
      final url = Uri.https(
        'flutter-update-31f2a-default-rtdb.firebaseio.com',
        '/products/${id}.json?auth=${authToken}',
      );
      */
      final _authority = "flutter-update-31f2a-default-rtdb.firebaseio.com";
      final _path = "/products/$id.json";
      final _params = {
        'auth': authToken,
      };
      final url = Uri.https(_authority, _path, _params);

      await http.patch(
        url,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
            //is favorite will be NOT UPDATED ... rimane quello memorizzato nel DB per lo specifico ID
          },
        ),
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    /*
    final url = Uri.https(
      'flutter-update-31f2a-default-rtdb.firebaseio.com',
      '/products/${id}.json?auth=${authToken}',
    );
    */
    final _authority = "flutter-update-31f2a-default-rtdb.firebaseio.com";
    final _path = "/products/$id.json";
    final _params = {
      'auth': authToken,
    };
    final url = Uri.https(_authority, _path, _params);

    //COMMON PATTERN: OPTIMISTIC DELETE  (senza await)... before removing we can copy it, if something goes wrong, then we can restore
    final existingProductIndex = _items.indexWhere(
      (element) => (element.id == id),
    );
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    // http.delete(url).then((response) {
    //   if (response.statusCode >= 400) {
    //     throw HttpException(
    //         'Could not delete product'); // cosi andiamo direttamente in catchError perchè e' una throw
    //   }
    //   existingProduct = null; // we remove it from the mem
    // }).catchError((_) {
    //   _items.insert(existingProductIndex, existingProduct);
    //   notifyListeners();
    // });

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException(
        'Could not delete product', //cosi andiamo a catchare in  user_product_screen
      );
    }
    existingProduct = null;

    //non dobbiamo mettere un body, ma e' sufficiente ID che passiamo tramite url
  }
}
