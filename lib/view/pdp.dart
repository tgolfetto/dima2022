import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../model/product_query.dart';
import '../model_view/cart.dart';
import '../model_view/product.dart';
import 'custom_theme.dart';

class Pdp extends StatefulWidget {
  final int model;

  const Pdp({super.key, required this.model});

  @override
  State<Pdp> createState() => _PdpState();
}

class _PdpState extends State<Pdp> {
  int dropdownValue = 0;

  ElevatedButton get _backButton {
    return ElevatedButton(
      style: buttonStyle,
      onPressed: () => Modular.to.navigate('/homepage'),
      child: const Icon(Icons.close),
    );
  }

  Widget get _addToCartButton {
    return ElevatedButton(
      style: buttonStyle,
      onPressed: () => Cart.addToCart(widget.model, dropdownValue),
      child: const Icon(Icons.add_shopping_cart),
    );
  }

  @override
  Widget build(BuildContext context) {
    ProductModel productModel = Product.retrieveProduct(widget.model);
    return Scaffold(
        body: Column(
      children: [
        Container(child: _backButton),
        Expanded(
          child: SingleChildScrollView(
            child: Expanded(
                child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: double.maxFinite,
                    child: Image.asset('assets/images/example.png'),
                  ),
                  Text('${widget.model}'),
                  Text('Product name: ${productModel.name}'),
                  Text('${productModel.price} €'),
                  DropdownButton<int>(
                    value: dropdownValue == 0
                        ? productModel.sizes[0]
                        : dropdownValue,
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
                    items: productModel.sizes
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text("$value"),
                      );
                    }).toList(),
                  ),
                  _addToCartButton,
                ],
              ),
            )),
          ),
        ),
      ],
    ));
  }
}
