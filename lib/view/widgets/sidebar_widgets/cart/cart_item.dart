import 'package:dima2022/view_models/cart_view_models/cart_item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/size_config.dart';
import '../../../../view_models/cart_view_models/cart_view_model.dart';
import '../../common/title_text.dart';
import '../../ui_widgets/glass_rounded_container.dart';

class CartItem extends StatelessWidget {
  final CartItemViewModel cartItemViewModel;

  CartItem(
    this.cartItemViewModel,
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItemViewModel.id),
      background: Container(
        color: Colors.transparent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ), //Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.red,
          size: 30,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: ((context) => AlertDialog(
                title: const Text('Are you sure?'),
                content:
                    const Text('Do you want to remove the item from the cart?'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text('NO')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('YES')),
                ],
              )),
        );
      },
      onDismissed: (direction) {
        Provider.of<CartViewModel>(context, listen: false)
            .removeItem(cartItemViewModel.productId);
      },
      child: GlassRoundedContainer(
        margin: EdgeInsets.only(
          bottom: getProportionateScreenHeight(20),
          left: getProportionateScreenWidth(3),
          right: getProportionateScreenWidth(3),
        ),
        itemPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        radius: BorderRadius.circular(20.0),
        opacity: 0.8,
        enableBorder: false,
        enableShadow: true,
        child: Container(
          color: Colors.white,
          height: 100,
          child: Row(
            children: <Widget>[
              LayoutBuilder(
                builder: (context, constraints) {
                  // Get the screen width and height from the MediaQuery object
                  double screenWidth = MediaQuery.of(context).size.width;
                  double screenHeight = MediaQuery.of(context).size.height;

                  // Determine if the screen width is lower than a certain threshold
                  bool showWidget = screenWidth < 1300;

                  return showWidget
                      ? Container()
                      : AspectRatio(
                          aspectRatio: 0.8,
                          child: Stack(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(5, 0),
                                        blurRadius: 5,
                                      ),
                                    ],
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          cartItemViewModel.imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                },
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: getProportionateScreenWidth(3)),
                  child: ListTile(
                    title: TitleText(
                      color: Colors.black87,
                      text: cartItemViewModel.title,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    subtitle: Row(
                      children: <Widget>[
                        const TitleText(
                          text: '\€ ',
                          color: Colors.teal,
                          fontSize: 12,
                        ),
                        TitleText(
                          text: cartItemViewModel.price.toString(),
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          iconSize: 17,
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            // Decrement the quantity value
                            Provider.of<CartViewModel>(context, listen: false)
                                .removeSingleItem(cartItemViewModel.productId);
                          },
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.teal.withAlpha(200),
                              borderRadius: BorderRadius.circular(10)),
                          child: TitleText(
                            color: Colors.white,
                            text: 'x${cartItemViewModel.quantity}',
                            fontSize: 13,
                          ),
                        ),
                        IconButton(
                          iconSize: 17,
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            // Increment the quantity value
                            Provider.of<CartViewModel>(context, listen: false)
                                .addSingleItem(cartItemViewModel.productId);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}