import 'package:flutter/material.dart';
import './custom_theme.dart';
import 'package:flutter_modular/flutter_modular.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {

  ElevatedButton get _backButton {
    return ElevatedButton(
      style: buttonStyle,
      onPressed: () => Modular.to.navigate('/homepage'),
      child: const Icon(Icons.close),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _backButton,
            const Text('Cart')
          ],
        ),
      );
  }
}
