import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../custom_theme.dart';

class LineItem extends StatefulWidget {
  final int model;
  final String name;
  final double price;
  final List<int> sizes;

  const LineItem({
    super.key,
    required this.model,
    required this.name,
    required this.price,
    required this.sizes,
  });

  @override
  State<LineItem> createState() => _LineItemState();
}

class _LineItemState extends State<LineItem> {
  int dropdownValue = 0;

  Widget get _addToCartButton {
    return ElevatedButton(
      style: CustomTheme.buttonStyleFill,
      onPressed: () => {
        //Cart.addToCart(widget.model, dropdownValue)
      },
      child: const Icon(Icons.add_shopping_cart),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  ///TODO: Open pdp
                },
                child: Image.asset('assets/images/example.jpg'),
                ),
            Text('${widget.model}'),
            Text('Product name: ${widget.name}'),
            Text('${widget.price} €'),
            DropdownButton<int>(
              value: dropdownValue == 0 ? widget.sizes[0] : dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (int? value) {
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: widget.sizes.map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text("$value"),
                );
              }).toList(),
            ),
            _addToCartButton,
          ],
        ),

    );
  }
}
