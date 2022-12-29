import 'package:flutter/foundation.dart';

import '../../models/product/product.dart';
import '../../models/request/request_status.dart';
import '../../models/user/user.dart';
import '../../models/request/request.dart';

class ContentViewModel with ChangeNotifier {
  late int _mainContentIndex = 0;
  late int _sideBarIndex = 6;
  late String _productId = '';

  ContentViewModel();

  ContentViewModel.fromExistingContent(int mainContentIndex, int sideBarIndex, String productId) {
    _mainContentIndex = mainContentIndex;
    _sideBarIndex = sideBarIndex;
    _productId = productId;
  }


  int get mainContentIndex => _mainContentIndex;
  int get sideBarIndex => _sideBarIndex;
  String get productId => _productId;

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

}
