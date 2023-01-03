import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../utils/size_config.dart';
import '../../../../view_models/cart_view_models/cart_view_model.dart';
import '../../../../view_models/order_view_models/orders_view_model.dart';
import '../../common/custom_button.dart';
import '../../common/title_text.dart';
import '../profile_side/user_input_widget.dart';
import 'cart_item.dart';

class CartSide extends StatelessWidget {
  static const pageIndex = 7;
  CartSide({Key? key}) : super(key: key);

  CartViewModel? cartViewModel;

  Widget _cartItems() {
    var items = cartViewModel!.cartItems.map((e) => CartItem(e)).toList();

    return Column(children: items);
  }

  Widget _price() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(5),
        vertical: getProportionateScreenHeight(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const TitleText(
            text: 'Total:',
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          TitleText(
            color: Colors.black54,
            text: '\€${cartViewModel!.totalAmount.toStringAsFixed(2)}',
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    cartViewModel = Provider.of<CartViewModel>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isKeyboardActive = MediaQuery.of(context).viewInsets.bottom > 0;
        final bottomPadding = isKeyboardActive
            ? MediaQuery.of(context).viewInsets.bottom
            : MediaQuery.of(context).padding.bottom;

        return Container(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: cartViewModel!.itemCount > 0
                ? Column(
                    children: <Widget>[
                      CardHeader(
                          formKey: GlobalKey(),
                          pageController: PageController(),
                          nextButton: false,
                          backButton: false,
                          textTitle: 'Cart',
                          textSubtitle: '${cartViewModel!.itemCount} Items'),
                      _cartItems(),
                      const Divider(
                        thickness: 1,
                        height: 70,
                      ),
                      _price(),
                      const SizedBox(height: 30),
                      //_submitButton(context),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OrderButton(
                          cart: cartViewModel!,
                        ),
                      ),
                      SizedBox(
                        height: bottomPadding,
                      )
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Lottie.asset('../assets/animated/empty_cart_1.json'),
                      Text(
                        'Add something ...',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color:
                              Color.fromARGB(255, 59, 59, 59).withOpacity(0.6),
                        ),
                      )
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final CartViewModel cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      transparent: false,
      text: !_isLoading ? 'Order Now' : null,
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<OrdersViewModel>(context, listen: false)
                  .addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
            },
      child: _isLoading ? const CircularProgressIndicator() : null,
    );
  }
}
