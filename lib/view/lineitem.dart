import 'package:flutter/material.dart';
import 'custom_theme.dart';

class LineItem extends StatelessWidget {
  final int model;
  final List<int> sizes;

  Widget get _addToCartButton {
    return ElevatedButton(
      style: buttonStyle,
      onPressed: () => () {
        ///@TODO: Add to cart the current item with size/color
      },
      child: const Icon(Icons.add_shopping_cart),
    );
  }

  const LineItem(
      {super.key,
      required this.model,
      required this.sizes,
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
          _SizeSelector(sizeList: sizes),
          _addToCartButton,
        ],
      ),
    ));
  }
}

class _SizeSelector extends StatefulWidget {
  final List<int> sizeList;
  const _SizeSelector({super.key, required this.sizeList});

  @override
  State<_SizeSelector> createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<_SizeSelector> {
  int dropdownValue = 0;

  @override
  Widget build(BuildContext context) {
    dropdownValue = widget.sizeList[0];
    return DropdownButton<int>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (int? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: widget.sizeList.map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text("$value"),
        );
      }).toList(),
    );
  }
}

