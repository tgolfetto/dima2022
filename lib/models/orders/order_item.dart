import '../cart/cart_item.dart';

// OrderItem represents an order placed by a customer, consisting of a list of products and associated metadata
class OrderItem {
  // unique identifier for the order
  late String? id;
  // total cost of the order
  final double amount;
  // list of products included in the order
  final List<CartItem> products;
  // date and time the order was placed
  final DateTime dateTime;

  OrderItem({
    this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });

  /*
  Creates a new OrderItem instance from a JSON object
  @requires orderData != null;
  @requires prodId != null;
  @requires orderData.containsKey('amount') && orderData.containsKey('dateTime') && orderData.containsKey('products');
  @ensures \result != null;
  @ensures \result.id == prodId;
  @ensures \result.amount == orderData['amount'];
  @ensures \result.dateTime == DateTime.parse(orderData['dateTime']);
  @ensures \result.products != null;
  */
  factory OrderItem.fromJson(String prodId, Map<String, dynamic> orderData) {
    return OrderItem(
      id: prodId,
      amount: orderData['amount'],
      dateTime: DateTime.parse(orderData['dateTime']),
      products: (orderData['products'] as List<dynamic>)
          .map(((e) => CartItem.fromJson(e)))
          .toList(),
    );
  }

  /*
  Converts the OrderItem instance to a JSON object
  @ensures \result != null;
  @ensures \result.containsKey('amount') && \result.containsKey('dateTime') && \result.containsKey('products');
  @ensures \result['amount'] == amount;
  @ensures \result['dateTime'] == dateTime.toIso8601String();
  @ensures \result['products'] == products.map((e) => e.toJson()).toList();
  */
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'dateTime': dateTime.toIso8601String(),
      'products': products.map((e) => e.toJson()).toList(),
    };
  }
}
