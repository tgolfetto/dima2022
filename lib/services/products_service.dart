import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/exceptions/http_exception.dart';

import '../utils/constants.dart';

import '../models/product/product.dart';
import '../models/product/products.dart';

class ProductsService {
  // Path to the products endpoint
  static const productsPath = "/products.json";
  // Path to the userFavorites endpoint
  static const userFavoritesPath = "/userFavorites";
  // The user's authentication token
  String? _authToken;
  // The ID of the user
  String? _userId;

  // Constructor for ProductsService
  // @param authToken the user's authentication token
  // @param userId the ID of the user
  ProductsService(this._authToken, this._userId);

  // Fetches a list of products from the database
  // @param filterByUser (optional) whether to filter the list by the current user
  // @return a list of Product objects
  // @throws HttpException if the request fails
  // @requires _authToken != null && _userId != null
  // @ensures returns a list of Product objects
  Future<List<Product>> fetchAndSetProducts([bool filterByUser = false]) async {
    Map<String, String> optionalParameters = filterByUser
        ? {
            "orderBy": "creatorId",
            "equalTo": _userId!,
          }
        : {};

    final _path = productsPath;
    final _params = optionalParameters;
    _params.addAll({
      'auth': _authToken!,
    });

    final url = Uri.https(baseUrl, _path, _params);

    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return [];
      }

      final _pathFavorite = "$userFavoritesPath/${_userId}.json";
      final _paramsFavorite = optionalParameters;
      _params.addAll({
        'auth': _authToken!,
      });
      final urlFavorite = Uri.https(baseUrl, _pathFavorite, _paramsFavorite);

      final favoriteResponse = await http.get(urlFavorite);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];

      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product.fromJson(prodId, prodData, favoriteData));
      });
      return loadedProducts;
    } catch (error) {
      throw HttpException(error.toString());
    }

  }

  // Adds a new product to the database
  // @param product the Product object to add
  // @return the added Product object
  // @throws HttpException if the request fails
  // @requires _authToken != null
  // @ensures returns the added Product object
  Future<Product> addProduct(Product product) async {
    final _path = productsPath;
    final _params = {
      'auth': _authToken,
    };

    final url = Uri.https(baseUrl, _path, _params);

    try {
      final response = await http.post(
        url,
        body: json.encode(product.toJson()),
      );

      //this is executed once the await finishes
      product.id = json.decode(response.body)['name'];

      //then the widgets ONLY that are listening will be re-built
      return product;
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  // Updates a product in the database
  // @param id the ID of the product to update
  // @param newProduct the updated Product object
  // @return the updated Product object
  // @throws HttpException if the request fails
  // @requires _authToken != null
  // @ensures returns the updated Product object
  Future<Product> updateProduct(String id, Product newProduct) async {
    final _path = "/products/$id.json";
    final _params = {
      'auth': _authToken!,
    };

    final url = Uri.https(baseUrl, _path, _params);

    try {
      await http.patch(
        url,
        body: json.encode(newProduct.toJson()),
      );
      return newProduct;
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  // Deletes a product from the database
  // @param _products the list of products to delete the product from
  // @param id the ID of the product to delete
  // @return the updated list of products
  // @throws HttpException if the request fails
  // @requires _authToken != null
  // @ensures returns the updated list of products
  Future<Products> deleteProduct(Products _products, String id) async {
    final _path = "/products/$id.json";
    final _params = {
      'auth': _authToken!,
    };

    final url = Uri.https(baseUrl, _path, _params);

    final existingProductIndex = _products.getExistingProductIndex(id);
    Product? existingProduct = _products.getExistingProduct(id);
    _products.deleteProduct(id);

    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        _products.insertAt(existingProductIndex, existingProduct);
        throw HttpException(
          'Could not delete product', //cosi andiamo a catchare in  user_product_screen
        );
      }
      existingProduct = null;
      return _products;
    } catch (error) {
      throw HttpException(error.toString());
    }
  }
}
