///@TODO: query product information

class ProductModel{
  final int sku;
  final String name;
  final int size;
  final String image;

  const ProductModel(this.sku, this.size, this.image, this.name);
}

class ProductService{
  static ProductModel getProduct(int sku){
    /// do a query
    return ProductModel(sku, 48, 'assets/images/example.png', 'name');
  }

  static List<ProductModel> getProductList(){
    /// do a query
    List<ProductModel> result = <ProductModel>[];
    for(int i = 0; i < 9; i++){
      result.add(getProduct(1));
    }
    return result;
  }
}
