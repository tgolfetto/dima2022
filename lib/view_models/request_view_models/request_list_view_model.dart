import 'package:flutter/foundation.dart';

import 'request_view_model.dart';
import '../../services/requests_service.dart';

import '../../models/request/request.dart';

class RequestListViewModel with ChangeNotifier {
  // a service that handles all the requests related operations, such as fetching, adding, and removing requests.
  late final RequestListService _requestListService;
  // list of requests
  late List<Request> _requests;

  RequestListViewModel() {
    _requests = [];
  }

  // Initializes the list of requests with the previous requests, if any, and the instance of the RequestListService.
  // @param token - the user's token.
  // @param userId - the user's id.
  // @param previousRequests - the previous list of requests, if any.
  RequestListViewModel.fromAuth(
      String? token, String? userId, RequestListViewModel? previousRequests) {
    _requests = previousRequests!._requests;
    _requestListService = RequestListService(token, userId);
  }

  // Returns a list of request view models based on the list of requests.
  // @return a list of request view models.
  List<RequestViewModel> get requests => _requests
      .map<RequestViewModel>(
          (product) => RequestViewModel.fromExistingRequest(product))
      .toList();

  // Requests the list of requests from the RequestListService and updates the list of requests.
  // @ensure requests will be updated with the fetched requests.
  Future<void> fetchRequests() async {
    _requests = await _requestListService.fetchRequests();
    notifyListeners();
  }

  // Returns request view model with the given id
  // @require id != null
  // @ensure result != null
  RequestViewModel findById(String id) {
    return requests.firstWhere((req) => req.id == id);
  }

  // Add request
  // @require requestViewModel != null
  Future<void> addRequest(RequestViewModel requestViewModel) async {
    _requests
        .add(await _requestListService.addRequest(requestViewModel.request));
    notifyListeners();
  }

  // Remove request
  // @require requestViewModel != null
  Future<void> removeRequest(RequestViewModel requestViewModel) async {
    _requests.remove(requestViewModel.request);
    _requests = await _requestListService.removeRequest(
      _requests,
      requestViewModel.request,
    );
    notifyListeners();
  }
}