import 'package:flutter/foundation.dart';

import '../../services/user_service.dart';

import '../../models/product/category.dart';
import '../../models/user/user.dart';

class UserViewModel with ChangeNotifier {
  late final UserService _userService;
  late final User _user;

  UserViewModel() {}

  UserViewModel.fromAuth(String? token, String? userId) {
    _userService = UserService(token, userId);
    getUser();
  }

  String get id => _user.id;
  String get name => _user.name;
  String get email => _user.email;
  String get phone => _user.phone;
  String get address => _user.address;
  String get profileImageUrl => _user.profileImageUrl;
  String get size => _user.size;
  int get shoeSize => _user.shoeSize;
  List<String> get favoriteBrands => _user.favoriteBrands;
  List<ItemCategory> get favoriteCategories => _user.favoriteCategories;

  Future<void> saveChanges() async {
    await _userService.updateUser(_user);
    notifyListeners();
  }

  Future<void> getUser() async {
    User u = await _userService.getUser();
    _user = u;
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