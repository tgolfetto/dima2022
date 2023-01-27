import 'package:flutter/foundation.dart';

import 'request.dart';
import 'request_status.dart';

class Requests with ChangeNotifier {
  // A list of products
  List<Request> _items;

  List<Request>? _assignedRequests;

  // Constructor that initializes _items with the given list
  Requests(this._items);

  // Getter for _items
  List<Request> get items => _items;

  List<Request> get getAssignedRequests => _assignedRequests ?? [];

  /*
  Returns the product with the given id
  If no such product exists, returns null
  @requires id != null;
  @ensures \result != null ==> \result.id == id;
  */
  Request findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  /*
  Sets _items to the given list and notifies listeners
  @requires items != null;
  @ensures _items == items;
  */
  set items(List<Request> items) {
    _items = items;
    notifyListeners();
  }

  /*
  Adds the given item to _items and notifies listeners
  @requires item != null;
  @ensures _items.size() == \old(_items.size()) + 1;
  */
  void addItem(Request item) {
    _items.add(item);
    notifyListeners();
  }

  /*
  Replaces the product with the given id with newP and notifies listeners
  @requires id != null && newP != null;
  @ensures (\exists int i; 0 <= i && i < _items.size(); _items.get(i).id == id) ==> _items.get(_items.indexWhere((element) => element.id == id)) == newP;
  */
  void updateItem(String id, Request newP) {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    _items[prodIndex] = newP;
    notifyListeners();
  }

  void setAssignedRequests(String userID) {
    _assignedRequests = items
        .where(
            (element) => element.clerk != null && element.clerk!.id == userID)
        .toList();
    notifyListeners();
  }

  Map<RequestStatus, List<Request>> groupAssignedRequestsByStatus() {
    var groups = <RequestStatus, List<Request>>{};
    for (var item in getAssignedRequests) {
      RequestStatus status = item.status;
      if (!groups.containsKey(status)) {
        groups[status] = [item];
      } else {
        groups[status]?.add(item);
      }
    }
    return groups;
  }
}
