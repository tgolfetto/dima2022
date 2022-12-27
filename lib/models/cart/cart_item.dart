import 'package:flutter/foundation.dart';

// CartItem represents an item in a shopping cart, consisting of a product and associated metadata
class CartItem with ChangeNotifier {
  // unique identifier for the product
  final String id;
  // name of the product
  final String title;
  // number of items of this product in the cart
  int quantity;
  // cost of a single item of this product
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });

  /* 
  Factory method for creating a CartItem object from a JSON object
  @requires json != null;
  @ensures \result != null;
  */
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      title: json['title'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }

  /*
  Return a map representation of the CartItem instance
  @ensures \result != null;
  */
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'quantity': quantity,
      'price': price,
    };
  }

  /*
  Increment the quantity of the item in the cart by 1
  @modifies quantity;
  @ensures quantity > \old(quantity);
  */
  void incrementQuantity() {
    quantity++;
    notifyListeners();
  }

  /*
  Decrement the quantity of the item in the cart by 1, if the quantity is greater than 1
  @modifies quantity;
  @ensures quantity < \old(quantity) || quantity == \old(quantity);
  */
  void decrementQuantity() {
    if (quantity > 1) {
      quantity--;
      notifyListeners();
    }
  }
}
