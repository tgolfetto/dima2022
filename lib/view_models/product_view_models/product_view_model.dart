import 'package:flutter/foundation.dart';

import '../../services/product_service.dart';

import '../../models/product/category.dart';
import '../../models/product/product.dart';
import '../../models/product/product_type.dart';

class ProductViewModel extends ChangeNotifier {
  // The ProductService instance used to make HTTP requests to the backend
  late final ProductService _productService;
  // The Product instance
  late Product _product;

  // Initializes a ProductViewModel with a new Product instance
  ProductViewModel() {
    _product = new Product();
  }

  // Initializes a ProductViewModel with an existing Product instance
  ProductViewModel.fromExistingProduct(Product existingProduct) {
    _product = existingProduct;
    _productService = ProductService(); //(_authToken, _userId);
  }

  // Returns the Product instance
  Product get getProduct => _product;

  // Returns whether the product is a favorite
  bool get isFavorite => _product.isFavorite!;
  // Returns the id of the product
  String? get id => _product.id;
  // Returns the title of the product
  String? get title => _product.title;
  // Returns the description of the product
  String? get description => _product.description;
  // Returns the price of the product
  double? get price => _product.price;
  // Returns the image url of the product
  String? get imageUrl => _product.imageUrl;
  // Returns the sizes of the product
  List<int>? get sizes => _product.sizes;

  // Toggles the favorite status of the product
  // @ensure The favorite status of the product will be updated and the ProductService will be updated with the new status
  Future<void> toggleFavoriteStatus() async {
    //OPTIMISTIC UPDATE

    final oldStatus = _product.isFavorite;
    _product.isFavorite = !oldStatus!;
    notifyListeners();

    bool result = await _productService.toggleFavoriteStatus(_product);
    if (result == false) {
      _product.setFavValue(oldStatus);
      notifyListeners();
    }
  }

  // Sets the id of the product
  // @require The id argument must not be null
  // @ensure The id of the product will be updated
  void setId(String? id) {
    _product.id = id;
  }

  // Sets the title of the product
  // @require The title argument must not be null
  // @ensure The title of the product will be updated
  void setTitle(String title) {
    _product.title = title;
  }

  // Sets the description of the product
  // @require The description argument must not be null
  // @ensure The description of the product will be updated
  void setDescription(String description) {
    _product.description = description;
  }

  // Sets the price of the product
  // @require The price argument must not be null
  // @ensure The price of the product will be updated
  void setPrice(double price) {
    _product.price = price;
  }

  // Sets the image url of the product
  // @require The imageUrl argument must not be null
  // @ensure The image url of the product will be updated
  void setImageUrl(String imageUrl) {
    _product.imageUrl = imageUrl;
  }

  // Sets whether the product is a favorite or not
  // @require The isFavorite argument must not be null
  // @ensure The favorite status of the product will be updated
  void setIsFavorite(bool isFavorite) {
    _product.isFavorite = isFavorite;
  }

  // Sets the categories the product belongs to
  // @require The categories argument must not be null and must contain at least one element
  // @ensure The categories of the product will be updated
  void setCategories(List<String> categories) {
    List<ItemCategory> itemCategories = categories.map((category) {
      return ItemCategory.values.firstWhere((itemCategory) =>
          itemCategory.toString().split('.').last == category);
    }).toList();
    _product.categories = itemCategories;
    notifyListeners();
  }

  // Sets the type of the product
  // @require The type argument must not be null
  // @ensure The type of the product will be updated
  void setType(ProductType type) {
    _product.type = type;
    notifyListeners();
  }

  // Sets the current stock of the product
  // @require The stock argument must be a non-negative integer
  // @ensure The stock of the product will be updated
  void setStock(int stock) {
    _product.stock = stock;
    notifyListeners();
  }

  // Sets the rating of the product
  // @require The rating argument must be a non-negative double
  // @ensure The rating of the product will be updated
  void setRating(double rating) {
    _product.rating = rating;
    notifyListeners();
  }

  // Sets the brand of the product
  // @require The brand argument must not be null
  // @ensure The brand of the product will be updated
  void setBrand(String brand) {
    _product.brand = brand;
    notifyListeners();
  }

  // Sets the material the product is made of
  // @require The material argument must not be null
  // @ensure The material of the product will be updated
  void setMaterial(String material) {
    _product.material = material;
    notifyListeners();
  }

  // Sets the color of the product
  // @require The color argument must not be null
  // @ensure The color of the product will be updated
  void setColor(String color) {
    _product.color = color;
    notifyListeners();
  }

  void setSize(String size) {
    _product.sizes = sizes;
    notifyListeners();
  }

  void setGender(String gender) {
    _product.gender = gender;
    notifyListeners();
  }

  void setMadeIn(String madeIn) {
    _product.madeIn = madeIn;
    notifyListeners();
  }
}
