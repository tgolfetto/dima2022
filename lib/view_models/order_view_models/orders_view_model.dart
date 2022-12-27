import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../services/orders_service.dart';

import '../../models/cart/cart_item.dart';
import '../../models/orders/orders.dart';
import '../../models/orders/order_item.dart';

class OrdersViewModel extends ChangeNotifier {
  // The OrdersService instance
  late final OrdersService _ordersService;
  // The Orders instance
  late final Orders _orders;

  // Initializes an OrdersViewModel with an empty Orders instance
  OrdersViewModel() {
    _orders = Orders([]);
  }

  // Initializes an OrdersViewModel with an OrdersService instance and an Orders instance
  OrdersViewModel.fromAuth(
      String? token, String? userId, OrdersViewModel? previousOrders) {
    _orders = previousOrders == null ? Orders([]) : previousOrders._orders;
    _ordersService = OrdersService(token, userId);
  }

  // Returns the items in the orders
  List<OrderItem> get items => _orders.items;

  // Fetches the orders from the OrdersService and updates the orders instance
  // @require The OrdersService instance must be initialized
  // @ensure The _orders instance will be updated with the fetched orders
  Future<void> fetchAndSetOrders() async {
    final orders = await _ordersService.fetchOrders();

    _orders.setOrders(orders);
    notifyListeners();
  }

  // Adds an order to the orders
  // @require The cartProducts and total arguments must not be null
  // @ensure The order will be added to the orders and the OrdersService will be updated with the new order
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final order_item = await _ordersService.addOrder(cartProducts, total);
    _orders.addOrder(order_item);
    notifyListeners();
  }
}
