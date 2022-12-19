///@TODO: query product information

class ProductModel{
  final int sku;
  final int model;
  final String name;
  final List<int> sizes;
  final String image;

  const ProductModel(this.sku, this.model, this.sizes, this.image, this.name);
}

class ProductService{
  static ProductModel getProduct(int sku){
    /// do a query
    return ProductModel(sku, 1, [44, 46, 48], 'assets/images/example.png', 'name');
  }

  static List<ProductModel> getProductList(){
    /// do a query
    List<ProductModel> result = <ProductModel>[];
    for(int i = 0; i < 9; i++){
      result.add(getProduct(99307));
    }
    return result;
  }
}
