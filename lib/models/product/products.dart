import 'package:flutter/foundation.dart';

import 'product.dart';

class Products with ChangeNotifier {
  // A list of products
  List<Product> _items;

  // Constructor that initializes _items with the given list
  Products(this._items);

  // Getter for _items
  get items => _items;

  /*
  Returns a list of favorite products (where isFavorite is true)
  @ensures \result.size() == (\num_int i; 0 <= i && i < _items.size();  _items.get(i).isFavorite == true);
  */
  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite!).toList();
  }

  /*
  Returns the product with the given id
  If no such product exists, returns null
  @requires id != null;
  @ensures \result != null ==> \result.id == id;
  */
  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  /*
  Sets _items to the given list and notifies listeners
  @requires items != null;
  @ensures _items == items;
  */
  void setItems(List<Product> items) {
    _items = items;
    notifyListeners();
  }

  /*
  Adds the given item to _items and notifies listeners
  @requires item != null;
  @ensures _items.size() == \old(_items.size()) + 1;
  */
  void addItem(Product item) {
    _items.add(item);
    notifyListeners();
  }

  /*
  Replaces the product with the given id with newP and notifies listeners
  @requires id != null && newP != null;
  @ensures (\exists int i; 0 <= i && i < _items.size(); _items.get(i).id == id) ==> _items.get(_items.indexWhere((element) => element.id == id)) == newP;
  */
  void updateItem(String id, Product newP) {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    _items[prodIndex] = newP;
    notifyListeners();
  }

  /*
  Removes the product with the given id from _items and notifies listeners
  @requires id != null;
  @ensures (\exists int i; 0 <= i && i < _items.size(); _items.get(i).id == id) ==>
            (\forall int j; 0 <= j && j < _items.size(); _items.get(j).id != id);
  */
  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }

  /*
  Returns the index of the product in the inventory with the given id, or -1 if no such product exists
  @requires id != null;
  @ensures \result == -1 || (0 <= \result && \result < _items.length && _items[\result].id == id);
  */
  int getExistingProductIndex(String id) {
    return _items.indexWhere((element) => element.id == id);
  }

  /*
  Returns the product in the inventory with the given id, or null if no such product exists
  @requires id != null;
  @ensures (\result == null) == (_items.indexWhere((element) => element.id == id) == -1);
  */
  Product? getExistingProduct(String id) {
    final existingProductIndex = getExistingProductIndex(id);
    return existingProductIndex == -1 ? null : _items[existingProductIndex];
  }

  /*
  Inserts the given product at the given index in the inventory, and notifies listeners
  @requires 0 <= index && index <= _items.length;
  @ensures p != null ==> (\old(_items.length) == _items.length - 1);
  @ensures p == null ==> (_items.length == \old(_items.length));
  */
  void insertAt(var index, Product? p) {
    if (p != null) _items.insert(index, p);
    notifyListeners();
  }
}
