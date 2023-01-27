import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/orders_service.dart';

import '../../models/cart/cart_item.dart';
import '../../models/orders/orders.dart';
import 'order_view_model.dart';

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
    _ordersService = OrdersService(token!, userId!);
  }

  // Returns the items in the orders
  List<OrderViewModel> get items => _orders.items
      .map<OrderViewModel>(
          (cartItem) => OrderViewModel.fromExistingCartItem(cartItem))
      .toList();

  int getTotalCount() {
    if (_orders.items.isEmpty) return 0;
    return _orders.items.map((e) => 1).reduce((a, b) => a + b);
  }

  double getAverageAmount() {
    if (_orders.items.isEmpty) return 0;
    final sum =
        _orders.items.map((order) => order.amount).reduce((a, b) => a + b);
    return sum / _orders.items.length;
  }

  double getMaxAmount() {
    if (_orders.items.isEmpty) return 0;
    return _orders.items
        .map((order) => order.amount)
        .reduce((a, b) => a > b ? a : b);
  }

  double getMinAmount() {
    if (_orders.items.isEmpty) return 0;
    return _orders.items
        .map((order) => order.amount)
        .reduce((a, b) => a < b ? a : b);
  }

  Map<String, List<OrderViewModel>> groupOrdersByMonth() {
    final monthFormat = DateFormat.MMMM();
    final result = <String, List<OrderViewModel>>{};
    for (var order in items) {
      final month = monthFormat.format(order.dateTime);
      result[month] ??= [];
      result[month]?.add(order);
    }
    return result;
  }

  Map<String, double> getOrdersPerMonthData() {
    final result = <String, double>{};
    final monthGroups = groupOrdersByMonth();
    for (var month in monthGroups.keys) {
      final monthAmount = monthGroups[month]!
          .map((order) => order.amount)
          .reduce((a, b) => a + b);
      result.putIfAbsent(month, () => monthAmount);
    }
    return result;
  }

  String computeExpensiveMonth() {
    final monthGroups = groupOrdersByMonth();
    String highestMonth = '';

    double highestAmount = 0;
    for (var month in monthGroups.keys) {
      final monthAmount = monthGroups[month]!
          .map((order) => order.amount)
          .reduce((a, b) => a + b);
      if (monthAmount > highestAmount) {
        highestMonth = month;
        highestAmount = monthAmount;
      }
    }
    return highestMonth;
  }

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
    final orderItem = await _ordersService.addOrder(cartProducts, total);
    _orders.addOrder(orderItem);
    notifyListeners();
  }
}
