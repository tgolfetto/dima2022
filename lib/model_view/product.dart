import '../model/product_query.dart';

///@TODO: retrieve product info

class Product{
  static List<ProductModel> retrieveProductList(){
    return ProductService.getProductList();
  }

  static ProductModel retrieveProduct(int model){
    return ProductService.getProduct(model);
  }
}