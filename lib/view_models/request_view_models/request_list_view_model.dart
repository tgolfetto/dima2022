import 'package:flutter/foundation.dart';

import '../../models/request/request_status.dart';
import '../../models/request/requests.dart';
import '../../services/request_service.dart';
import 'request_view_model.dart';
import '../../services/requests_service.dart';

class RequestListViewModel with ChangeNotifier {
  // a service that handles all the requests related operations, such as fetching, adding, and removing requests.
  late final RequestListService _requestListService;
  // list of requests
  late Requests _requests;

  RequestListViewModel() {
    _requests = Requests([]);
  }

  // Initializes the list of requests with the previous requests, if any, and the instance of the RequestListService.
  // @param token - the user's token.
  // @param userId - the user's id.
  // @param previousRequests - the previous list of requests, if any.
  RequestListViewModel.fromAuth(
      String? token, String? userId, RequestListViewModel? previousRequests) {
    _requests =
        previousRequests == null ? Requests([]) : previousRequests._requests;
    _requestListService = RequestListService(token!, userId!);

    RequestService.authToken = token;
    RequestService.userId = userId;
  }

  // Returns a list of request view models based on the list of requests.
  // @return a list of request view models.
  List<RequestViewModel> get requests => _requests.items.reversed
      .map((request) => RequestViewModel.fromExistingRequest(request))
      .toList();

  List<RequestViewModel> get assignedRequests => _requests.getAssignedRequests
      .map((request) => RequestViewModel.fromExistingRequest(request))
      .toList();

  List<RequestViewModel> get pendingRequests => requests
      .where((element) => element.status == RequestStatus.pending)
      .toList();

  List<RequestViewModel> get outstandingRequests => requests
      .where((element) =>
          element.user.id != RequestService.userId &&
          (element.status == RequestStatus.pending ||
              (element.status == RequestStatus.accepted &&
                  element.clerk!.id == RequestService.userId)))
      .toList();

  void updateAssignedRequests() {
    _requests.setAssignedRequests(RequestService.userId!);
    notifyListeners();
  }

  Map<RequestStatus, List<RequestViewModel>> groupByRequestStatus() {
    Map<RequestStatus, List<RequestViewModel>> groupedViewModels = {};
    for (var entry in _requests.groupAssignedRequestsByStatus().entries) {
      groupedViewModels[entry.key] = entry.value
          .map((r) => RequestViewModel.fromExistingRequest(r))
          .toList();
    }
    return groupedViewModels;
  }

  Map<String, List<RequestViewModel>> groupRequestsByUser() {
    final result = <String, List<RequestViewModel>>{};
    for (var r in requests) {
      final user = r.user;
      result[user.id] ??= [];
      result[user.id]?.add(r);
    }
    return result;
  }

  Map<String, List<RequestViewModel>> groupRequestsByProduct() {
    final result = <String, List<RequestViewModel>>{};
    for (var r in requests) {
      final product = r.products.first;
      result[product.id!] ??= [];
      result[product.id]?.add(r);
    }
    return result;
  }

  Map<String, int> countRequestsByProduct() {
    final groupedRequests = groupRequestsByProduct();
    final result = <String, int>{};
    for (var entry in groupedRequests.entries) {
      final productId = entry.key;
      final requests = entry.value;
      result[productId] = requests.length;
    }
    return result;
  }

  // Returns request view model with the given id
  // @require id != null
  // @ensure result != null
  RequestViewModel findById(String id) {
    return requests.firstWhere((req) => req.id == id);
  }

  // Requests the list of requests from the RequestListService and updates the list of requests.
  // @ensure requests will be updated with the fetched requests.
  Future<void> fetchRequests() async {
    _requests.items = await _requestListService.fetchRequests();
    notifyListeners();
  }

  Future<void> fetchAllRequests() async {
    _requests.items = await _requestListService.fetchAllRequests();
    updateAssignedRequests();
    notifyListeners();
  }

  // Add request
  // @require requestViewModel != null
  Future<void> addRequest(RequestViewModel requestViewModel) async {
    _requests.items
        .add(await _requestListService.addRequest(requestViewModel.request));
    notifyListeners();
  }

  // Remove request
  // @require requestViewModel != null
  Future<void> removeRequest(RequestViewModel requestViewModel) async {
    _requests.items.remove(requestViewModel.request);
    _requests.items = await _requestListService.removeRequest(
      _requests.items,
      requestViewModel.request,
    );
    notifyListeners();
  }
}
