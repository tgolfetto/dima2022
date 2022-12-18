import 'package:flutter/material.dart';
import '../model/cart_query.dart';
import '../model/product_query.dart';
import '../model_view/cart.dart';
import './custom_theme.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'lineitem.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({super.key});

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  ElevatedButton get _backButton {
    return ElevatedButton(
      style: buttonStyle,
      onPressed: () => Modular.to.navigate('/homepage'),
      child: const Icon(Icons.close),
    );
  }

  Column get _productList {
    CartModel userCart = Cart.retrieveCart();
    List<LineItem> items = <LineItem>[];
    for (ProductModel p in userCart.productList) {
      items.add(LineItem(sku: p.sku, size: p.size, isAddable: false));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(child: _backButton),
        Expanded(
          child: SingleChildScrollView(child: _productList),
        ),
      ],
    ));
  }
}
