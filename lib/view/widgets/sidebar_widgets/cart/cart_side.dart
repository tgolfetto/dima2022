import 'package:dima2022/view/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../utils/size_config.dart';
import '../../../../view_models/cart_view_models/cart_view_model.dart';
import '../../../../view_models/content_view_models/content_view_model.dart';
import '../../../../view_models/order_view_models/orders_view_model.dart';
import '../../common/custom_button.dart';
import '../../common/title_text.dart';
import '../../homepage_widgets/plp.dart';
import '../filter.dart';
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
                        textTitle: 'Cart',
                        textSubtitle: '${cartViewModel!.itemCount} Items',
                        backButton: true,
                        backIcon: Icons.close,
                        onPressedBack: () {
                          final content = context.read<ContentViewModel>();
                          if (context.layout.breakpoint < LayoutBreakpoint.md) {
                            content.updateMainContentIndex(Plp.pageIndex);
                          } else {
                            content.updateSideBarIndex(Filter.pageIndex);
                          }
                        },
                      ),
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
                : cartViewModel!.isOrdered
                    ? Column(
                        children: [
                          CardHeader(
                            formKey: GlobalKey(),
                            pageController: PageController(),
                            nextButton: false,
                            textTitle: 'Thank you for your order!',
                            textSubtitle:
                                "Your order has been received and is being processed. We'll send you a confirmation email shortly with the details of your order.",
                            backButton: true,
                            backIcon: Icons.close,
                            onPressedBack: () {
                              final content = context.read<ContentViewModel>();
                              cartViewModel!.setIsOrdered();
                              if (context.layout.breakpoint <
                                  LayoutBreakpoint.md) {
                                content
                                    .updateMainContentIndex(Filter.pageIndex);
                              } else {
                                content.updateSideBarIndex(Filter.pageIndex);
                              }
                            },
                          ),
                          Lottie.asset('../assets/animated/order_ok.json'),
                        ],
                      )
                    : Column(
                        children: [
                          CardHeader(
                            formKey: GlobalKey(),
                            pageController: PageController(),
                            nextButton: false,
                            textTitle: 'Add something ...',
                            textSubtitle: '',
                            backButton: true,
                            backIcon: Icons.close,
                            onPressedBack: () {
                              final content = context.read<ContentViewModel>();
                              if (context.layout.breakpoint <
                                  LayoutBreakpoint.md) {
                                content
                                    .updateMainContentIndex(Filter.pageIndex);
                              } else {
                                content.updateSideBarIndex(Filter.pageIndex);
                              }
                            },
                          ),
                          Lottie.asset('../assets/animated/empty_cart_1.json'),
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
              widget.cart.setIsOrdered();
              widget.cart.clear();
            },
      child: _isLoading
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
          : null,
    );
  }
}
