import 'package:flutter/foundation.dart';

class ContentViewModel with ChangeNotifier {
  late int _mainContentIndex = 0;
  late int _sideBarIndex = 6;
  late String _productId = '';
  late bool _filterFavorites = false;
  Map<String, dynamic> _filters = {};

  ContentViewModel();

  // ContentViewModel.fromExistingContent(
  //   int mainContentIndex,
  //   int sideBarIndex,
  //   String productId,
  //   bool filterFavorites,
  //   Map<String, dynamic> filters,
  // ) {
  //   _mainContentIndex = mainContentIndex;
  //   _sideBarIndex = sideBarIndex;
  //   _productId = productId;
  //   _filterFavorites = filterFavorites;
  //   _filters = filters;
  // }

  int get mainContentIndex => _mainContentIndex;
  int get sideBarIndex => _sideBarIndex;
  String get productId => _productId;
  bool get filterFavorites => _filterFavorites;
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

  void toggleFilterFavorites() {
    _filterFavorites = !_filterFavorites;
    notifyListeners();
  }

  void setFilters(Map<String, dynamic> filters) {
    _filters = filters;
    notifyListeners();
  }
}
