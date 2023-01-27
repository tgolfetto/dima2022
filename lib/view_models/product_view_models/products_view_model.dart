import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/product/category.dart';
import '../../models/product/product_type.dart';
import 'product_view_model.dart';

import '../../services/product_service.dart';
import '../../services/products_service.dart';

import '../../models/product/product.dart';
import '../../models/product/products.dart';

class ProductListViewModel extends ChangeNotifier {
  // The ProductsService instance
  late final ProductsService _productsService;
  // The Products instance
  late final Products _products;

  late bool isLoaded;

  // Initializes a ProductListViewModel with an empty Products instance
  ProductListViewModel() {
    _products = Products([]);
  }

  // Initializes a ProductListViewModel with a ProductsService instance and a Products instance
  ProductListViewModel.fromAuth(
      String? token, String? userId, ProductListViewModel? previousProducts) {
    _products =
        previousProducts == null ? Products([]) : previousProducts._products;
    _productsService = ProductsService(token!, userId!);
    isLoaded = false;
    ProductService.authToken = token;
    ProductService.userId = userId;
  }

  // Returns a list of ProductViewModel instances
  List<ProductViewModel> get items => _products.items
      .map<ProductViewModel>(
          (product) => ProductViewModel.fromExistingProduct(product))
      .toList();

  // Returns a list of ProductViewModel instances marked as favorites
  List<ProductViewModel> get favoriteItems {
    return items.where((element) => element.isFavorite).toList();
  }

  // Filters the products by multiple criteria
  // minPrice The minimum price of the range (null if no price range criteria is specified)
  // maxPrice The maximum price of the range (null if no price range criteria is specified)
  // categories A list of categories to filter by (empty list if no category criteria is specified)
  // productTypes A list of product types to filter by (empty list if no product type criteria is specified)
  // minRating The minimum rating to filter by (null if no rating criteria is specified)
  // @param filters data strucure that contains all the multiple criteria
  // @return A list of ProductViewModel instances that match the specified criteria
  List<ProductViewModel> filterByMultipleCriteria(
      Map<String, dynamic> filters) {
    double? minPrice = filters['priceMin'];
    double? maxPrice = filters['priceMax'];
    List<ItemCategory>? categories = filters['categories'];
    List<ProductType>? productTypes = filters['productTypes'];
    int? minRating = filters['rating'];
    bool filterFavorites = filters['favorite'];

    return items.where((product) {
      if (filterFavorites && !product.isFavorite) {
        return false;
      }
      if (minPrice != null && product.price! < minPrice) {
        return false;
      }
      if (maxPrice != null && product.price! > maxPrice) {
        return false;
      }
      if (categories != null &&
          categories.isNotEmpty &&
          categories
              .where((element) => !product.categories.contains(element))
              .isNotEmpty) {
        return false;
      }
      if (productTypes != null &&
          productTypes.isNotEmpty &&
          !productTypes.contains(product.type)) {
        return false;
      }
      if (minRating != null && product.rating! < minRating) {
        return false;
      }
      return true;
    }).toList();
  }

  // Returns a ProductViewModel instance with the specified id
  // @require The id argument must not be null
  // @ensure The returned ProductViewModel instance will have the specified id
  ProductViewModel findById(String id) {
    return items.firstWhere((prod) => prod.id == id);
  }

  // Adds a product to the products
  // @require The product argument must not be null
  // @ensure The product will be added to the products and the ProductsService will be updated with the new product
  Future<void> addProduct(ProductViewModel product) async {
    Product p = await _productsService.addProduct(product.getProduct);
    _products.addItem(p);
    notifyListeners();
  }

  // Updates a product in the products
  // @require The id and newProduct arguments must not be null
  // @ensure The product with the specified id will be updated with the new product and the ProductsService will be updated with the new product
  Future<void> updateProduct(String id, ProductViewModel newProduct) async {
    Product p = await _productsService.updateProduct(id, newProduct.getProduct);
    _products.updateItem(id, p);
    notifyListeners();
  }

  // Deletes a product from the products
  // @require The id argument must not be null
  // @ensure The product with the specified id will be deleted from the products and the ProductsService will be updated
  Future<void> deleteProduct(String id) async {
    await _productsService.deleteProduct(_products, id);
    _products.deleteProduct(id);
    notifyListeners();
  }

  // Fetches the products from the ProductsService and updates the products instance
  // @require The ProductsService instance must be initialized
  // @ensure The _products instance will be updated with the fetched products
  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final loadedProducts =
        await _productsService.fetchAndSetProducts(filterByUser);
    _products.setItems(loadedProducts);
    notifyListeners();
  }

  void refreshProduct(ProductViewModel newProduct) async {
    _products.updateItem(newProduct.id!, newProduct.getProduct);
    notifyListeners();
  }
}
