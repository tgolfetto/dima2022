import 'package:flutter/foundation.dart';

class ContentViewModel with ChangeNotifier {
  late int _mainContentIndex = 0;
  late int _sideBarIndex = 6;
  late String _productId;

  Map<String, dynamic> _filters = {};

  ContentViewModel();

  int get mainContentIndex => _mainContentIndex;
  int get sideBarIndex => _sideBarIndex;
  String get productId => _productId;
  Map<String, dynamic> get filters => _filters;

  void updateMainContentIndex(int index) {
    _mainContentIndex = index;
    notifyListeners();
  }

  void updateSideBarIndex(int index) {
    _sideBarIndex = index;
    notifyListeners();
  }

  void updateProductId(String id) {
    _productId = id;
    notifyListeners();
  }

  void setFilters(Map<String, dynamic> filters) {
    _filters = filters;
    notifyListeners();
  }
}
