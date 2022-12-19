import 'package:dima2022/model/cart_query.dart';
import 'package:dima2022/model_view/product.dart';

///@TODO: get cart info

class Cart{
  static CartModel retrieveCart(){
    int userId = 1;
    return CartService.getCart(userId);
  }

  static CartModel addToCart(int model, int size){
    int userId = 1;
    return CartService.addToCart(userId, model, size);
  }

  static CartModel removeFromCart(int model, int size){
    int userId = 1;
    return CartService.removeFromCart(userId, model, size);
  }

}