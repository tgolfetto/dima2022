import '../model/product_query.dart';

///@TODO: retrieve product info

class Product{
  static List<ProductModel> retrieveProductList(){
    return ProductService.getProductList();
  }
}