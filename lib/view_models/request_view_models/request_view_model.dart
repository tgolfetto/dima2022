import 'package:dima2022/services/request_service.dart';
import 'package:dima2022/view_models/product_view_models/product_view_model.dart';
import 'package:dima2022/view_models/user_view_models/user_view_model.dart';
import 'package:flutter/foundation.dart';

import '../../models/product/product.dart';
import '../../models/request/request_status.dart';
import '../../models/user/user.dart';
import '../../models/request/request.dart';

class RequestViewModel with ChangeNotifier {
  late final Request _request;

  late final RequestService _requestService;

  RequestViewModel();

  // Constructs a new RequestViewModel object from an existing Request object.
  // @param existingRequest: the Request object to be converted into a RequestViewModel object.
  RequestViewModel.fromExistingRequest(Request existingRequest) {
    _request = existingRequest;
    _requestService = RequestService();
  }

  //@return the Request object associated with this RequestViewModel.
  Request get request => _request;

  // @return the id of the Request object associated with this RequestViewModel.
  String get id => _request.id!;

  //@return the user associated with the Request object associated with this RequestViewModel.
  User get user => _request.user;

  //@return the clerk associated with the Request object associated with this RequestViewModel.
  User? get clerk => _request.clerk;
  List<Product> get products => _request.products;
  String get message => _request.message!;
  RequestStatus get status => _request.status;

  void createRequest(User user, Product product) {
    _request = Request(user: user, products: [product]);
  }

  // @requires newStatus != null
  // @ensure request.status == newStatus
  void updateStatus(RequestStatus newStatus) {
    _request.updateStatus(newStatus);
    _requestService.updateRequest(_request);
    notifyListeners();
  }

  // @requires newClerk != null
  // @ensure request.clerk == newClerk
  void assignClerk(UserViewModel? newClerk) {
    if (newClerk != null) {
      _request.assignClerk(newClerk.user);
      _request.updateStatus(RequestStatus.accepted);
    } else {
      _request.unassignClerk();
      _request.updateStatus(RequestStatus.pending);
    }

    _requestService.updateRequest(_request);

    notifyListeners();
  }

  void setUser(UserViewModel user) {
    _request.user = user.user;
    notifyListeners();
  }

  // @requires product != null
  // @ensure the product will be added to the product list of the request
  void addProduct(ProductViewModel product) {
    _request.products.add(product.getProduct);
    notifyListeners();
  }

  // @requires value != null
  // @ensure request.message == value
  void updateMessage(String value) {
    _request.message = value;
  }
}
