import 'package:dima2022/model/product_query.dart';

///@TODO: query cart information

class CartProductModel{
  final int sku;
  final int model;
  final String name;
  final int size;
  final String image;

  const CartProductModel(this.sku, this.model, this.size, this.image, this.name);
}

class CartModel{
  final int cartId;
  final int totalQty;
  final int totalCost;
  final List<CartProductModel> productList;

  const CartModel(this.cartId, this.totalQty, this.totalCost, this.productList);
}

class CartService{
  static CartModel getCart(int userId){
    /// do a query
    List<CartProductModel> cartProductList = [];
    List<ProductModel> mockProducts =  ProductService.getProductList();
    for(ProductModel p in mockProducts){
      cartProductList.add(CartProductModel(p.sku, p.model, p.sizes[0], p.image, p.name));
    }
    return CartModel(1, 9, 10,cartProductList);
  }
}
