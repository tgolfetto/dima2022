import 'package:flutter/foundation.dart';

import '../../services/cart_service.dart';

import '../../models/cart/cart.dart';
import '../../models/cart/cart_item.dart';
import 'cart_item_view_model.dart';

class CartViewModel with ChangeNotifier {
  // The Cart instance
  late final Cart _cart;
  // The CartService instance
  late final CartService _cartService;

  // Initializes a CartViewModel with a new Cart instance
  CartViewModel() {
    _cart = Cart();
  }

  // Initializes a CartViewModel with a CartService instance and a new Cart instance
  CartViewModel.fromAuth(String? token, String? userId) {
    _cart = Cart();
    _cartService = CartService(token, userId);
    _getCart();
  }

  // Returns the items in the cart
  Map<String, CartItem> get items {
    return _cart.items;
  }

  List<CartItemViewModel> get cartItems {
    return _cart.items.entries
        .map((e) => CartItemViewModel.fromExistingCartItem(e.value))
        .toList();
  }

  // Returns the number of items in the cart
  int get itemCount {
    return _cart.itemCount;
  }

  // Returns the total amount of the items in the cart
  double get totalAmount {
    return _cart.totalAmount;
  }

  // Fetches the cart from the CartService and updates the cart instance
  // @require The CartService instance must be initialized
  // @ensure The _cart instance will be updated with the fetched cart
  Future<void> _getCart() async {
    final cart = await _cartService.getCart();
    _cart.setCart(cart.cartItems);
    notifyListeners();
  }

  // Adds an item to the cart
  // @require The productId, imageUrl, price, and title arguments must not be null
  // @ensure The item will be added to the cart and the CartService will be updated with the new cart
  void addItem(String productId, String imageUrl, double price, String title) {
    _cart.addItem(productId, imageUrl, price, title);
    _cartService.updateCart(_cart);
    notifyListeners();
  }

  // Adds a single instance of an item to the cart
  // @require The productId argument must not be null
  // @ensure A single instance of the item will be added to the cart and the CartService will be updated with the new cart
  void addSingleItem(String productId) {
    _cart.addSingleItem(productId);
    _cartService.updateCart(_cart);
    notifyListeners();
  }

  // Removes an item from the cart
  // @require The productId argument must not be null
  // @ensure The item will be removed from the cart and the CartService will be updated with the new cart
  void removeItem(String productId) {
    _cart.removeItem(productId);
    _cartService.updateCart(_cart);
    notifyListeners();
  }

  // Removes a single instance of an item from the cart
  // @require The productId argument must not be null
  // @ensure A single instance of the item will be removed from the cart and the CartService will be updated with the new cart
  void removeSingleItem(String productId) {
    _cart.removeSingleItem(productId);
    _cartService.updateCart(_cart);
    notifyListeners();
  }

  // Clears the cart
  // @require The CartService instance must be initialized
  // @ensure The cart will be emptied and the CartService will be updated with the new cart
  void clear() async {
    _cart.clear();
    await _cartService.updateCart(_cart);
    notifyListeners();
  }
}
