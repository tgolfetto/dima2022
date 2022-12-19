import 'package:flutter/material.dart';
import 'custom_theme.dart';

class CartLineItem extends StatelessWidget {
  final int model;
  final int size;

  Widget get _removeFromCartButton {
    return ElevatedButton(
      style: buttonStyle,
      onPressed: () => () {
        ///@TODO: Remove from cart the current item with size/color
      },
      child: const Icon(Icons.remove_shopping_cart),
    );
  }

  const CartLineItem(
      {super.key,
        required this.model,
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
              Text('Product name: $model'),
              Text('Size: $size'),
              _removeFromCartButton,
            ],
          ),
        ));
  }
}


