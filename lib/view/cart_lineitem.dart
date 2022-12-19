import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../model_view/cart.dart';
import 'custom_theme.dart';

class CartLineItem extends StatelessWidget {
  final int model;
  final String name;
  final double price;
  final int size;

  Widget get _removeFromCartButton {
    return ElevatedButton(
      style: buttonStyle,
      onPressed: () => Cart.removeFromCart(model, size),
      child: const Icon(Icons.remove_shopping_cart),
    );
  }

  const CartLineItem(
      {super.key,
        required this.model,
        required this.name,
        required this.price,
        required this.size,
        });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: double.maxFinite,
                child: Image.asset('assets/images/example.png'),
              ),
              Text('Product name: $name'),
              Text('Size: $size'),
              _removeFromCartButton,
            ],
          ),
        ));
  }
}


