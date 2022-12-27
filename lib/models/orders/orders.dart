import 'package:flutter/foundation.dart';

import 'order_item.dart';

// Orders is a class that manages a list of OrderItem instances
// and provides methods for modifying and accessing that list
class Orders with ChangeNotifier {
  // list of OrderItem instances
  List<OrderItem> _orders;

  Orders(this._orders);

  /*
  Returns the list of OrderItem instances
  @ensures \result == _orders;
  */
  get items => _orders;

  /*
  Sets the list of OrderItem instances to the given list
  @requires orders != null;
  @ensures _orders == orders;
  */
  void setOrders(List<OrderItem> orders) {
    _orders = orders;
    notifyListeners();
  }

  /*
  Adds the given OrderItem instance to the list of orders
  @requires orderItem != null;
  @ensures _orders.length == \old(_orders.length) + 1;
  @ensures _orders.contains(orderItem);
  */
  void addOrder(OrderItem orderItem) {
    _orders.add(orderItem);
    notifyListeners();
  }
}
