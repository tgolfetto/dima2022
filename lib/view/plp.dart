import 'package:flutter/material.dart';
import 'package:dima2022/view/lineitem.dart';
import '../model/product_query.dart';
import '../model_view/product.dart';

class Plp extends StatefulWidget {
  const Plp({super.key});

  @override
  State<Plp> createState() => _PlpState();
}

class _PlpState extends State<Plp> {
  final int _productPerRow = 2;

  @override
  Widget build(BuildContext context) {
    List<Row> rows = <Row>[];
    List<Widget> items = [];
    List<ProductModel> products = Product.retrieveProductList();
    for (int i = 1; i <= products.length; i++) {
      ProductModel p = products[i-1];
      items.add(LineItem(model: p.model, name: p.name, price: p.price, sizes: p.sizes));
      if (i != 1 && (i % _productPerRow == 0 || i == products.length - 1)) {
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items,
        ));
        items = <LineItem>[];
      }
    }
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: rows),
    );
  }
}
