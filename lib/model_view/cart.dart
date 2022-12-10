import 'package:dima2022/model/cart_query.dart';

///@TODO: get cart info

class Cart{
  static CartModel retrieveCart(){
    int userId = 1;
    return CartService.getCart(userId);
  }
}