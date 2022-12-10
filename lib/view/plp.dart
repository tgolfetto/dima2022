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

  @override
  Widget build(BuildContext context) {
    List<LineItem> items = <LineItem>[];
    for(ProductModel p in Product.retrieveProductList()){
      items.add(LineItem(sku: p.sku, size: p.size, isAddable: true));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: items,
    );
  }
}