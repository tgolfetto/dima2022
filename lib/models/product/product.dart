import 'package:flutter/foundation.dart';

import 'category.dart';
import 'product_type.dart';

class Product with ChangeNotifier {
  //the id of the product
  String? id;
  //the title of the product
  String? title;
  //a description of the product
  String? description;
  //the price of the product
  double? price;
  //the URL of the product's image
  String? imageUrl;
  // a boolean representing whether the product is a favorite or not
  //it's not final, because it can be changable after the product is created
  bool? isFavorite;
  //a list of ItemCategory values representing the categories the product belongs to
  List<ItemCategory>? categories;
  //a ProductType value representing the type of the product
  ProductType? type;
  //an integer representing the number of units of the product in stock
  int? stock;
  //a numeric value representing the rating of the product
  num? rating;
  //the brand of the product
  String? brand;
  //the material of the product
  String? material;
  //the color of the product
  String? color;
  //the size of the product
  List<int>? sizes;
  //the gender the product is intended for
  String? gender;
  //the country where the product was made
  String? madeIn;

  Product({
    this.id,
    this.title,
    this.description,
    this.price,
    this.imageUrl,
    this.isFavorite = false,
    this.categories,
    this.type,
    this.stock,
    this.rating = 0,
    this.brand,
    this.material,
    this.color,
    this.sizes,
    this.gender,
    this.madeIn,
  });

  /*
  Creates a Product object from the given JSON-formatted data.
  @param prodId the id of the product
  @param prodData the JSON-formatted data for the product
  @param favData (optional) the JSON-formatted data for the user's favorite products
  @return the Product object represented by the given data
  @ensures the returned Product object is equal to the one represented by the given data
  */
  factory Product.fromJson(
    String prodId,
    Map<String, dynamic> prodData,
    Map<String, dynamic>? favData,
  ) {
    List<ItemCategory> categories = [];
    if (prodData['categories'] != null)
      for (var category in prodData['categories']) {
        categories.add(categoryFromString(category));
      }

    var newp = Product(
      id: prodId, //json['name'], //json['id'],
      title: prodData['title'],
      description: prodData['description'],
      price: prodData['price'],
      imageUrl: prodData['imageUrl'],
      isFavorite: favData == null ? false : favData[prodId] ?? false,
      categories: categories,
      type: typeFromString(prodData['type']),
      stock: prodData['stock'],
      rating: prodData['rating'],
      brand: prodData['brand'],
      material: prodData['material'],
      color: prodData['color'],
      sizes: prodData['sizes'] == null
          ? [0]
          : prodData['sizes'].split(',').map((e) => int.parse(e)).toList(),
      gender: prodData['gender'],
      madeIn: prodData['madeIn'],
    );

    return newp;
  }

  /*
  Returns a Map<String, dynamic> object representing the Product object in JSON format.
  @return a Map<String, dynamic> object representing the Product object in JSON format
  @ensures the returned Map<String, dynamic> object represents the Product object in JSON format
  */
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      //'isFavorite': isFavorite,
      'categories': categories != null
          ? categories!.map((e) => e.toString().split('.')[1]).toList()
          : null,
      'type': type != null ? type.toString().split('.')[1] : null,
      'stock': stock,
      'rating': rating,
      'brand': brand,
      'material': material,
      'color': color,
      'sizes': sizes,
      'gender': gender,
      'madeIn': madeIn,
    };
  }

  /*
  Returns a string representation of the Product object.
  @return a string representation of the Product object
  @ensures the returned string represents the Product object
  */
  @override
  String toString() {
    return 'Product{id: $id, title: $title, description: $description, price: $price, imageUrl: $imageUrl, isFavorite: $isFavorite, categories: $categories, type: $type, stock: $stock, rating: $rating, brand: $brand, material: $material, color: $color, sizes: $sizes, gender: $gender, madeIn: $madeIn}';
  }

  /*
  Sets the value of the isFavorite attribute to the given value.
  @param newValue the new value to set for the isFavorite attribute
  @modifies the value of the isFavorite attribute
  @ensures the value of the isFavorite attribute is set to the given value
  */
  void setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }
}
