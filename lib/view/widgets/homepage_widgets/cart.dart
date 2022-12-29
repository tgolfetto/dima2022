import 'package:flutter/material.dart';
import '../../custom_theme.dart';
import '../cart_line_item.dart';

class CartWidget extends StatefulWidget {
  static const routeName = '/cart';

  const CartWidget({super.key});

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  ElevatedButton get _backButton {
    return ElevatedButton(
      style: CustomTheme.buttonStyleOutline,
      onPressed: () => {},
      child: const Icon(Icons.close),
    );
  }

  final int _productPerRow = 2;

  @override
  Widget build(BuildContext context) {
    List<Row> rows = <Row>[];
    List<Widget> items = [];
    /*CartModel userCart = Cart.retrieveCart();
    List<CartProductModel> products = userCart.productList;
    for (int i = 1; i <= products.length; i++) {
      CartProductModel p = products[i - 1];
      items.add(CartLineItem(model: p.model, name: p.name, price: p.price, size: p.size));
      if (i != 1 && (i % _productPerRow == 0 || i == products.length - 1)) {
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items,
        ));
        items = <CartLineItem>[];
      }
    }*/

    /// Mock items
    for (int i = 0; i < 10; i++) {
      items.add(CartLineItem(
          model: 1, index: i, name: 'T-shirt', price: 19.99, size: 48));
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