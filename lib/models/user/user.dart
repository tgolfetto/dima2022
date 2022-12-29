import 'package:flutter/foundation.dart';

import '../product/category.dart';

class User with ChangeNotifier {
  // id of the user
  late String? _id;
  // name of the user
  late String? _name;
  // email of the user
  late String _email;
  // phone number of the user
  late String? _phone;

  //TODO:
  // whether the user is a clerk or not
  late bool _isClerk;

  // address of the user
  late String? _address;
  // profile image url of the user
  late String? _profileImageUrl;
  // size of the user
  late String? _size;
  // shoe size of the user
  late int? _shoeSize;
  // reward points of the user
  late int? _rewardPoints;
  // favorite brands of the user
  late List<String> _favoriteBrands;
  // favorite categories of the user
  late List<ItemCategory> _favoriteCategories;

  // constructs a new User instance
  // @param id: id of the user
  // @param name: name of the user
  // @param email: email of the user
  // @param phone: phone number of the user
  // @param address: address of the user
  // @param profileImageUrl: profile image url of the user
  // @param size: size of the user
  // @param shoeSize: shoe size of the user
  User({
    String? id,
    String? name,
    required String email,
    String? phone,
    String? address,
    String? profileImageUrl,
    String? size,
    int? shoeSize,
  }) {
    _id = id;
    _name = name;
    _email = email;
    _phone = phone;
    _address = address;
    _profileImageUrl = profileImageUrl;
    _size = size;
    _shoeSize = shoeSize;
    _rewardPoints = 0;
    _favoriteBrands = [];
    _favoriteCategories = [];
  }

  // constructs a new User instance from a JSON object
  // @param userData: JSON object containing user data
  User.fromJson(Map<String, dynamic> userData) {
    _id = userData['id'];
    _name = userData['name'];
    _email = userData['email'];
    _phone = userData['phone'];
    _address = userData['address'];
    _profileImageUrl = userData['profile_image_url'];
    _size = userData['size'];
    _shoeSize = userData['shoe_size'];
    _rewardPoints = userData['reward_points'];
    _favoriteBrands = userData['favorite_brands'] != null
        ? List<String>.from(userData['favorite_brands'])
        : [];
    _favoriteCategories = userData['favorite_categories'] != null
        ? (userData['favorite_categories'])
            .map((e) => categoryFromString(e))
            .toList()
        : [];
  }

  // returns a JSON object representation of the User instance
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': _name,
      'email': _email,
      'phone': _phone,
      'address': _address,
      'profile_image_url': _profileImageUrl,
      'size': _size,
      'shoe_size': _shoeSize,
      'reward_points': _rewardPoints,
      'favorite_brands': _favoriteBrands,
      'favorite_categories':
          _favoriteCategories.map((e) => e.toString()).toList()
    };
  }

  // id of the user
  String get id => _id!;

  // name of the user
  String get name => _name!;

  // email of the user
  String get email => _email;

  // phone of the user
  String get phone => _phone!;

  // address of the user
  String get address => _address!;

  // URL of the profile image of the user
  String get profileImageUrl => _profileImageUrl!;

  // size of the user
  String get size => _size!;

  // shoe size of the user
  int get shoeSize => _shoeSize!;

  // favorite brands of the user
  List<String> get favoriteBrands => _favoriteBrands;

  // favorite categories of the user
  List<ItemCategory> get favoriteCategories => _favoriteCategories;

  /*
  Sets the user's ID to a new value and notifies any listeners of the change
  @param newId the new ID for the user
  */
  set id(String newId) {
    _id = newId;
    notifyListeners();
  }

  /**
  Sets the user's name to a new value and notifies any listeners of the change
  @param newName the new name for the user
  */
  set name(String newName) {
    _name = newName;
    notifyListeners();
  }

  /**
  Sets the user's email to a new value and notifies any listeners of the change
  @param newEmail the new email for the user
  */
  set email(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }

  /**
  Sets the user's phone number to a new value and notifies any listeners of the change
  @param newPhone the new phone number for the user
  */
  set phone(String newPhone) {
    _phone = newPhone;
    notifyListeners();
  }

  /**
  Sets the user's address to a new value and notifies any listeners of the change
  @param newAddress the new address for the user
  */
  set address(String newAddress) {
    _address = newAddress;
    notifyListeners();
  }

  /**
  Sets the URL of the user's profile image to a new value and notifies any listeners of the change
  @param newProfileImageUrl the new URL for the user's profile image
  */
  set profileImageUrl(String newProfileImageUrl) {
    _profileImageUrl = newProfileImageUrl;
    notifyListeners();
  }

  /**
  Sets the user's size to a new value and notifies any listeners of the change
  @param newSize the new size for the user (e.g. "S", "M", "L")
  */
  set size(String newSize) {
    _size = newSize;
    notifyListeners();
  }

  /**
  Sets the user's shoe size to a new value and notifies any listeners of the change
  @param newShoeSize the new shoe size for the user
  */
  set shoeSize(int newShoeSize) {
    _shoeSize = newShoeSize;
    notifyListeners();
  }

  /**
  Adds a brand to the list of favorite brands for the user.
  @param brand the brand to add
  @requires brand != null
  @modifies _favoriteBrands
  @effects _favoriteBrands is modified to include the given brand
  */
  void addFavoriteBrand(String brand) {
    _favoriteBrands.add(brand);
    notifyListeners();
  }

  /**
  Removes a brand from the list of favorite brands for the user.
  @param brand the brand to remove
  @requires brand != null
  @modifies _favoriteBrands
  @effects _favoriteBrands is modified to remove the given brand
  */
  void removeFavoriteBrand(String brand) {
    _favoriteBrands.remove(brand);
    notifyListeners();
  }

  /**
  Adds a category to the list of favorite categories for the user.
  @param category the category to add
  @requires category != null
  @modifies _favoriteCategories
  @effects _favoriteCategories is modified to include the given category
  */
  void addFavoriteCategory(ItemCategory category) {
    _favoriteCategories.add(category);
    notifyListeners();
  }

  /**
  Removes a category from the list of favorite categories for the user.
  @param category the category to remove
  @requires category != null
  @modifies _favoriteCategories
  @effects _favoriteCategories is modified to remove the given category
  */
  void removeFavoriteCategory(ItemCategory category) {
    _favoriteCategories.remove(category);
    notifyListeners();
  }
}
