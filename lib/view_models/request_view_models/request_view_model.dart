import 'package:flutter/foundation.dart';

import '../../models/product/product.dart';
import '../../models/request/request_status.dart';
import '../../models/user/user.dart';
import '../../models/request/request.dart';

class RequestViewModel with ChangeNotifier {
  late final Request _request;

  RequestViewModel();

  // Constructs a new RequestViewModel object from an existing Request object.
  // @param existingRequest: the Request object to be converted into a RequestViewModel object.
  RequestViewModel.fromExistingRequest(Request existingRequest) {
    _request = existingRequest;
  }

  //@return the Request object associated with this RequestViewModel.
  Request get request => _request;

  // @return the id of the Request object associated with this RequestViewModel.
  String get id => _request.id!;

  //@return the user associated with the Request object associated with this RequestViewModel.
  User get user => _request.user;

  //@return the clerk associated with the Request object associated with this RequestViewModel.
  User get clerk => _request.clerk!;
  List<Product> get products => _request.products;
  String get message => _request.message!;
  RequestStatus get status => _request.status;

  // @requires newStatus != null
  // @ensure request.status == newStatus
  void updateStatus(RequestStatus newStatus) {
    _request.updateStatus(newStatus);
    notifyListeners();
  }

  // @requires newClerk != null
  // @ensure request.clerk == newClerk
  void assignClerk(User newClerk) {
    _request.clerk = newClerk;
    notifyListeners();
  }

  // @requires request != null
  // @ensure _request == request
  void createRequest(Request request) {
    _request = request;
    notifyListeners();
  }

  // @requires value != null
  // @ensure request.message == value
  void updateMessage(String value) {
    _request.message = value;
  }
}