import 'package:flutter/material.dart';
import 'custom_theme.dart';

class LineItem extends StatelessWidget {
  final int sku;
  final int size;
  final bool isAddable;

  Widget get _addToCartButton {
    return ElevatedButton(
      style: buttonStyle,
      onPressed: () => () {
        ///@TODO: Add to cart the current item with size/color
      },
      child: const Icon(Icons.add_shopping_cart),
    );
  }

  Widget get _removeFromCartButton {
    return ElevatedButton(
      style: buttonStyle,
      onPressed: () => () {
        ///@TODO: Remove from cart the current item with size/color
      },
      child: const Icon(Icons.remove_shopping_cart),
    );
  }

  const LineItem(
      {super.key,
      required this.sku,
      required this.size,
      required this.isAddable});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            width: 300,
            height: 300,
            child: Image.asset('assets/images/example.png'),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Product name: ${sku!}'), Text('Size: ${size!}')],
          ),
          isAddable ? _addToCartButton : _removeFromCartButton,
        ],
      ),
    );
  }
}
