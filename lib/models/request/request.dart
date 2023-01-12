import 'package:flutter/foundation.dart';
import '../product/product.dart';
import 'request_status.dart';
import '../user/user.dart';

class Request with ChangeNotifier {
  // id of the request
  String? id;
  // a User object representing the user who made the request
  late final User user;
  // a User object representing the clerk assigned to the request (null if not assigned)
  late User? clerk;
  // a list of Product objects representing the products in the request
  final List<Product> products;
  // a string containing any additional message from the user (null if not provided)
  late String? message;
  // a RequestStatus object representing the current status of the request
  late RequestStatus status;

  Request({
    this.id,
    required this.user,
    this.clerk,
    required this.products,
    this.message,
    this.status = RequestStatus.pending,
  });

  /*
  Converts the Request object to a JSON-formatted map.
  @return the Request object as a JSON-formatted map
  @ensures the returned map represents the Request object in a JSON-formatted manner
  */
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> items = {};
    for (var product in products) {
      var proData = product.toJson();
      items.putIfAbsent(product.id!, () => proData); // [product.id!] = proData;
    }

    return {
      'user': user.toJson(),
      'clerk': clerk?.toJson(),
      'products': items, //products.map((product) => product.toJson()).toList(),
      'message': message,
      'status': status.toString().split('.')[1],
    };
  }

  /*
  Converts the given JSON-formatted map to a Request object.
  @param requestData the JSON-formatted map to convert
  @return the Request object represented by the given map
  @ensures the returned Request object is equal to the one represented by the given map
  */
  Request.fromJson(MapEntry<String, dynamic> requestData)
      : id = requestData.key, // ['id'],
        user = User.fromJson(requestData.value['user']),
        clerk = requestData.value['clerk'] == null
            ? null
            : User.fromJson(requestData.value['clerk']),
        products = (requestData.value['products'] as Map<String, dynamic>)
            .entries
            .map((e) => Product.fromJson(e.key, e.value, null))
            .toList(),
        message = requestData.value['message'],
        status = statusFromString(requestData.value['status']);

  /*
  Updates the status of the request to the given value.
  @param newStatus the new status for the request
  @modifies status
  @effects status is set to the given value
  */
  void updateStatus(RequestStatus newStatus) {
    status = newStatus;
    notifyListeners();
  }

  /*
  Assigns the given user as the clerk for the request.
  @param newClerk the user to assign as the clerk for the request
  @modifies clerk
  @effects clerk is set to the given value
  */
  void assignClerk(User newClerk) {
    clerk = newClerk;
    notifyListeners();
  }

  void unassignClerk() {
    clerk = null;
    notifyListeners();
  }
}
