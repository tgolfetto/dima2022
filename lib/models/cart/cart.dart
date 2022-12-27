import 'package:flutter/foundation.dart';

import 'cart_item.dart';

class Cart with ChangeNotifier {
  // A map of product IDs to CartItem objects
  Map<String, CartItem> cartItems = {};

  // A copy of the cartItems map
  Map<String, CartItem> get items {
    return {...cartItems};
  }

  // Creates a new Cart instance
  Cart();

  // Factory constructor for Cart that takes a map of cart data and creates a Cart object
  // @require cartData is not null and contains valid CartItem data
  // @ensure returns a Cart object with the items from cartData
  factory Cart.fromJson(Map<String, dynamic> cartData) {
    final Map<String, CartItem> items = {};
    for (var product in cartData.entries) {
      final CartItem item = CartItem.fromJson(product.value);
      items[product.key] = item;
    }
    return Cart()..cartItems = items;
  }

  // Converts the Cart object to a JSON map
  // @require cartItems is not null and contains valid CartItem objects
  // @ensure returns a map with the CartItem data from the cart
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> items = {};
    cartItems.forEach((key, cartItem) {
      items[key] = cartItem.toJson();
    });
    return items;
  }

  // Getter for the number of items in the cart
  // @require cartItems is not null
  // @ensure returns the number of items in the cart
  int get itemCount {
    return cartItems.length;
  }

  // Sets the items in the cart to a new map of items
  // @require cart is not null and contains valid CartItem objects
  // @ensure cartItems is set to the new map of items and listeners are notified
  void setCart(Map<String, CartItem> cart) {
    cartItems = cart;
    notifyListeners();
  }

  // Calculates the total amount for all items in the cart
  // @require cartItems is not null and contains valid CartItem objects with valid prices
  // @ensure returns the total amount for all items in the cart
  double get totalAmount {
    return cartItems.values.fold(
        0, (total, cartItem) => total + cartItem.price * cartItem.quantity);
  }

  // Adds a new item to the cart or increments the quantity of an existing item
  // @param productId the ID of the product to add
  // @param price the price of the product
  // @param title the title of the product
  // @require productId, price, and title are not null
  // @ensure adds a new item to the cart or increments the quantity of an existing item, and notify listeners
  void addItem(String productId, double price, String title) {
    if (cartItems.containsKey(productId)) {
      cartItems[productId]!.incrementQuantity();
    } else {
      cartItems[productId] = CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price);
    }
    notifyListeners();
  }

  // Increments the quantity of an existing item in the cart
  // @param productId the ID of the product to add
  // @require productId is not null and there is an existing item with that ID in the cart
  // @ensure increments the quantity of the existing item in the cart and notify listeners
  void addSingleItem(String productId) {
    if (cartItems.containsKey(productId)) {
      cartItems[productId]!.incrementQuantity();
    }
    notifyListeners();
  }

  // Removes an item from the cart
  // @param productId the ID of the product to remove
  // @require productId is not null and there is an existing item with that ID in the cart
  // @ensure removes the item from the cart and notify listeners
  void removeItem(String productId) {
    cartItems.remove(productId);
    notifyListeners();
  }

  // Removes a single instance of an item from the cart
  // @param productId the ID of the product to remove
  // @require productId is not null and there is an existing item with that ID in the cart
  // @ensure removes a single instance of the item from the cart, or removes the item if it was the last instance, and notify listeners
  void removeSingleItem(String productId) {
    if (!cartItems.containsKey(productId)) {
      return;
    }
    if (cartItems[productId]!.quantity > 1) {
      cartItems[productId]!.decrementQuantity();
    } else {
      cartItems.remove(productId);
    }
    notifyListeners();
  }

  // Clears all items from the cart
  // @ensure cartItems is set to an empty map and listeners are notified
  void clear() {
    cartItems = {};
    notifyListeners();
  }
}
