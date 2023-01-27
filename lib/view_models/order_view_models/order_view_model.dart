import 'package:flutter/material.dart';

import '../../models/orders/order_item.dart';
import '../cart_view_models/cart_item_view_model.dart';

class OrderViewModel extends ChangeNotifier {
  late final OrderItem _order;

  OrderViewModel.fromExistingCartItem(OrderItem existingOrderItem) {
    _order = existingOrderItem;
  }

  String get id => _order.id!;
  double get amount => _order.amount;
  List<CartItemViewModel> get products => _order.products
      .map<CartItemViewModel>(
          (cartItem) => CartItemViewModel.fromExistingCartItem(cartItem))
      .toList();
  DateTime get dateTime => _order.dateTime;

  num getSingleItems() {
    return _order.products.map((e) => e.quantity).reduce((a, b) => a + b);
  }

  void updateOrder(OrderItem order) {
    _order = order;
    notifyListeners();
  }
}
