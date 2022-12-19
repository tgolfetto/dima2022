///@TODO: query product information

class ProductModel{
  final int model;
  final String name;
  final List<int> sizes;
  final String image;
  final double price;

  const ProductModel(this.model, this.sizes, this.image, this.price, this.name);
}

class ProductService{
  static ProductModel getProduct(int model){
    /// do a query that groups all the
    return ProductModel(model, [44, 46, 48], 'assets/images/example.png', 99.99, 'T-Shirt Black');
  }

  static List<ProductModel> getProductList(){
    /// do a query
    List<ProductModel> result = <ProductModel>[];
    for(int i = 0; i < 9; i++){
      result.add(getProduct(1));
    }
    return result;
  }

  static int getSku(int model, int size){
    // do a query
    return 99307;
  }
}
