// import 'package:flutter/material.dart';
// import 'package:layout/layout.dart';

// import '../custom_theme.dart';

// class CartLineItem extends StatelessWidget {
//   final int index;
//   final int model;
//   final String name;
//   final double price;
//   final int size;

//   Widget get _removeFromCartButton {
//     return ElevatedButton(
//       style: CustomTheme.buttonStyleFill,
//       onPressed: () => {
//         //Cart.removeFromCart(model, size)
//       },
//       child: const Icon(Icons.remove_shopping_cart),
//     );
//   }

//   const CartLineItem(
//       {Key? key,
//       required this.index,
//       required this.model,
//       required this.name,
//       required this.price,
//       required this.size})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final responsiveCardDecoration = BreakpointValue(
//       xs: BoxDecoration(
//         color: const Color.fromARGB(255, 195, 126, 126),
//         border: Border(
//           bottom: BorderSide(color: Theme.of(context).dividerColor),
//         ),
//       ),
//       sm: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//     );
//     return Container(
//       decoration: responsiveCardDecoration.resolve(context),
//       alignment: Alignment.center,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           SizedBox(
//             width: double.maxFinite,
//             child: Image.asset('assets/images/example.png'),
//           ),
//           Text('Product name: $index - $name'),
//           Text('Size: $size'),
//           _removeFromCartButton,
//         ],
//       ),
//     );
//   }
// }
