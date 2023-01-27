import 'package:flutter/foundation.dart';

import '../../services/user_service.dart';

import '../../models/product/category.dart';
import '../../models/user/user.dart';

class UserViewModel with ChangeNotifier {
  late final UserService _userService;
  late User _user;

  UserViewModel(){
    _user = User(id: '', email: ''); // Initialization needed after logout
  }

  UserViewModel.fromAuth(String? token, String? userId) {
    _userService = UserService(token!, userId!);
  }

  UserViewModel.fromExistingUser(this._user);

  User get user => _user;
  String get id => _user.id;
  String get name => _user.name;
  String get email => _user.email;
  String get phone => _user.phone;

  String get address => _user.address;

  bool get isClerk => _user.isClerk;

  String get profileImageUrl => _user.profileImageUrl;

  String get size => _user.size;

  String get shoeSizeString =>
      _user.shoeSize != 0 ? _user.shoeSize.toString() : '';

  List<String> get favoriteBrands => _user.favoriteBrands;

  List<ItemCategory> get favoriteCategories => _user.favoriteCategories;

  @override
  bool operator ==(Object other) {
    try {
      return identical(this, other) ||
          other is UserViewModel &&
              runtimeType == other.runtimeType &&
              id == other.id;
    }catch(e){
      if(kDebugMode){
        print('### AUTH COMPARISON ERROR $e');
      }
      return false;
    }
  }

  @override
  int get hashCode => id.hashCode;

  Future<void> saveChanges() async {
    _user = await _userService.updateUser(_user);
    notifyListeners();
  }

  Future<void> getUser() async {
    _user = await _userService.getUser();
    notifyListeners();
  }

  Future<void> getUserById(String id) async {
    _user = await _userService.getUserById(id);
    notifyListeners();
  }

  set id(String newId) {
    _user.id = newId;
    notifyListeners();
  }

  set name(String newName) {
    _user.name = newName;
    notifyListeners();
  }

  set email(String newEmail) {
    _user.email = newEmail;
    notifyListeners();
  }

  set phone(String newPhone) {
    _user.phone = newPhone;
    notifyListeners();
  }

  set address(String newAddress) {
    _user.address = newAddress;
    notifyListeners();
  }

  set profileImageUrl(String newProfileImageUrl) {
    _user.profileImageUrl = newProfileImageUrl;
    notifyListeners();
  }

  set size(String newSize) {
    _user.size = newSize;
    notifyListeners();
  }

  set shoeSize(int newShoeSize) {
    _user.shoeSize = newShoeSize;
    notifyListeners();
  }

  void addFavoriteBrand(String brand) {
    _user.favoriteBrands.add(brand);
    notifyListeners();
  }

  void removeFavoriteBrand(String brand) {
    _user.favoriteBrands.remove(brand);
    notifyListeners();
  }

  void addFavoriteCategory(ItemCategory category) {
    _user.favoriteCategories.add(category);
    notifyListeners();
  }

  void removeFavoriteCategory(ItemCategory category) {
    _user.favoriteCategories.remove(category);
    notifyListeners();
  }
}
