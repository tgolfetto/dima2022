import 'package:flutter/foundation.dart';

import '../../models/product/product.dart';
import '../../models/request/request_status.dart';
import '../../models/user/user.dart';
import '../../models/request/request.dart';

class ContentViewModel with ChangeNotifier {
  late int _mainContentIndex = 0;
  late int _sideBarIndex = 6;
  late String _productId = '';
  late bool _filterFavorites = false;

  ContentViewModel();

  ContentViewModel.fromExistingContent(int mainContentIndex, int sideBarIndex, String productId, bool filterFavorites) {
    _mainContentIndex = mainContentIndex;
    _sideBarIndex = sideBarIndex;
    _productId = productId;
    _filterFavorites = filterFavorites;
  }


  int get mainContentIndex => _mainContentIndex;
  int get sideBarIndex => _sideBarIndex;
  String get productId => _productId;
  bool get filterFavorites => _filterFavorites;

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

}
