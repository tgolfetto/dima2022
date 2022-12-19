import 'package:flutter/material.dart';
import '../model/cart_query.dart';
import '../model_view/cart.dart';
import './custom_theme.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'cart_lineitem.dart';

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
    List<CartLineItem> items = <CartLineItem>[];
    for (CartProductModel p in userCart.productList) {
      items.add(CartLineItem(model: p.model, size: p.size));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: items,
    );
  }

  final int _productPerRow = 2;

  @override
  Widget build(BuildContext context) {
    List<Row> rows = <Row>[];
    List<Widget> items = [];
    CartModel userCart = Cart.retrieveCart();
    List<CartProductModel> products = userCart.productList;
    for (int i = 1; i <= products.length; i++) {
      CartProductModel p = products[i - 1];
      items.add(CartLineItem(model: p.model, size: p.size));
      if (i != 1 && (i % _productPerRow == 0 || i == products.length - 1)) {
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items,
        ));
        items = <CartLineItem>[];
      }
    }

    return Scaffold(
        body: Column(
          children: [
            Container(child: _backButton),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: rows),
              ),
            ),
          ],
        ));
  }
}