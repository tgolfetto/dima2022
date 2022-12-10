import 'package:dima2022/model/product_query.dart';

///@TODO: query cart information

class CartModel{
  final int cartId;
  final int totalQty;
  final int totalCost;
  final List<ProductModel> productList;

  const CartModel(this.cartId, this.totalQty, this.totalCost, this.productList);
}

class CartService{
  static CartModel getCart(int userId){
    /// do a query
    return CartModel(1, 9, 10, ProductService.getProductList());
  }
}
