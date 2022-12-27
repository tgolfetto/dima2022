import 'package:flutter/foundation.dart';

import '../../models/cart/cart_item.dart';

class CartItemViewModel with ChangeNotifier {
  // The cart item this view model is based on
  final CartItem _cartItem;

  CartItemViewModel(this._cartItem);

  // The ID of the cart item
  String get id {
    return _cartItem.id;
  }

  // The title of the cart item
  String get title {
    return _cartItem.title;
  }

  // The quantity of the cart item
  int get quantity {
    return _cartItem.quantity;
  }

  // The price of the cart item
  double get price {
    return _cartItem.price;
  }

  // Increment the quantity of the cart item
  // @require  The current quantity of the cart item is not at the maximum allowed value
  // @ensure   The quantity of the cart item is increased by 1
  void incrementQuantity() {
    _cartItem.incrementQuantity();
    notifyListeners();
  }

  // Decrement the quantity of the cart item
  // @require  The current quantity of the cart item is not at the minimum allowed value (i.e. greater than 0)
  // @ensure   The quantity of the cart item is decreased by 1
  void decrementQuantity() {
    _cartItem.decrementQuantity();
    notifyListeners();
  }
}
