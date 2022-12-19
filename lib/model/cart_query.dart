import 'package:dima2022/model/product_query.dart';

///@TODO: query cart information

class CartProductModel{
  final int model;
  final String name;
  final int size;
  final double price;
  final String image;

  const CartProductModel(
      this.model, this.size, this.image, this.name, this.price);
}

class CartModel{
  final int cartId;
  final int totalQty;
  final double totalCost;
  final List<CartProductModel> productList;

  const CartModel(this.cartId, this.totalQty, this.totalCost, this.productList);
}

class CartService{
  static CartModel getCart(int userId){
    /// do a query to retrieve all the products in the cart for user $userId
    List<CartProductModel> cartProductList = [];
    List<ProductModel> mockProducts = ProductService.getProductList();
    double cartTotal = 0.0;
    for (ProductModel p in mockProducts) {
      cartProductList
          .add(CartProductModel(p.model, p.sizes[0], p.image, p.name, p.price));
      cartTotal += p.price;
    }
    return CartModel(1, cartProductList.length, cartTotal, cartProductList);
  }

  static CartModel addToCart(int userId, int model, int size) {
    /// do an insert query of item of type $model of size $size
    return getCart(userId);
  }

  static CartModel removeFromCart(int userId, int model, int size) {
    /// do an delete query of item of type $model of size $size
    return getCart(userId);
  }
}
