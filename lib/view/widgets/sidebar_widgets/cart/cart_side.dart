import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../view_models/cart_view_models/cart_view_model.dart';
import '../../../../view_models/content_view_models/content_view_model.dart';
import '../../../../view_models/order_view_models/orders_view_model.dart';

import '../../common/custom_button.dart';
import '../../common/title_text.dart';
import '../../homepage_widgets/barcode_scanner.dart';
import '../../homepage_widgets/orders/orders_page.dart';
import '../../homepage_widgets/plp/plp.dart';
import '../../homepage_widgets/requests/requests_page.dart';
import '../../homepage_widgets/screen_builder.dart';
import '../../../../utils/size_config.dart';
import '../filter.dart';
import '../order_side/order_side.dart';
import '../profile_side/user_input_widget.dart';
import '../requests_side/request_side.dart';
import '../scanner_instructions.dart';
import 'cart_item.dart';

class CartSide extends StatefulWidget {
  static const pageIndex = 7;

  const CartSide({Key? key}) : super(key: key);

  @override
  State<CartSide> createState() => CartSideState();
}

class CartSideState extends State<CartSide> {
  late CartViewModel cartViewModel = Provider.of<CartViewModel>(context);

  Widget _cartItems() {
    var items = cartViewModel.cartItems.map((e) => CartItem(e)).toList();
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
            text: '€ ${cartViewModel.totalAmount.toStringAsFixed(2)}',
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
        double topPadding,
        double bottomPadding,
        bool isKeyboardActive,
        double screenWidth,
        double screenHeight,
      ) {
        return SingleChildScrollView(
          child: Margin(
            margin: EdgeInsets.only(
              top: getProportionateScreenHeight(10) +
                  MediaQuery.of(context).padding.top,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0), //.copyWith(top: topPadding),
              child: cartViewModel.itemCount > 0
                  ? Column(
                      children: <Widget>[
                        CardHeader(
                          formKey: GlobalKey(),
                          pageController: PageController(),
                          topPadding: topPadding,
                          nextButton: false,
                          textTitle: 'Cart',
                          textSubtitle: '${cartViewModel.itemCount} Items',
                          backButton: true,
                          backIcon: Icons.close,
                          onPressedBack: () {
                            final content = context.read<ContentViewModel>();
                            if (context.layout.breakpoint <
                                LayoutBreakpoint.md) {
                              content.updateMainContentIndex(Plp.pageIndex);
                            } else {
                              switch (content.mainContentIndex) {
                                case BarcodeScannerWidget.pageIndex:
                                  {
                                    content.updateSideBarIndex(
                                      ScannerInstructions.pageIndex,
                                    );
                                    break;
                                  }
                                case RequestPage.pageIndex:
                                  {
                                    content.updateSideBarIndex(
                                      RequestSide.pageIndex,
                                    );
                                    break;
                                  }
                                case OrdersPage.pageIndex:
                                  {
                                    content.updateSideBarIndex(
                                      OrderSide.pageIndex,
                                    );
                                    break;
                                  }
                                default:
                                  {
                                    content.updateSideBarIndex(
                                      Filter.pageIndex,
                                    );
                                  }
                              }
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
                            cart: cartViewModel,
                          ),
                        ),
                        SizedBox(
                          height: bottomPadding,
                        )
                      ],
                    )
                  : cartViewModel.isOrdered
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
                              key: const Key('cartOrderedBack'),
                              onPressedBack: () {
                                final content =
                                    context.read<ContentViewModel>();
                                cartViewModel.setIsOrdered();
                                if (context.layout.breakpoint <
                                    LayoutBreakpoint.md) {
                                  content.updateMainContentIndex(Plp.pageIndex);
                                } else {
                                  content.updateSideBarIndex(Filter.pageIndex);
                                }
                              },
                            ),
                            Lottie.asset('assets/animated/order_ok.json'),
                          ],
                        )
                      : Column(
                          children: [
                            CardHeader(
                              formKey: GlobalKey(),
                              pageController: PageController(),
                              topPadding: topPadding,
                              nextButton: false,
                              textTitle: 'Add something ...',
                              textSubtitle: '',
                              backButton: true,
                              backIcon: Icons.close,
                              onPressedBack: () {
                                final content =
                                    context.read<ContentViewModel>();
                                if (context.layout.breakpoint <
                                    LayoutBreakpoint.md) {
                                  content.updateMainContentIndex(Plp.pageIndex);
                                } else {
                                  content.updateSideBarIndex(Filter.pageIndex);
                                }
                              },
                            ),
                            Lottie.asset('assets/animated/empty_cart_1.json'),
                          ],
                        ),
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
  OrderButtonState createState() => OrderButtonState();
}

class OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      key: const Key('cartOrderNowButton'),
      outline: false,
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
                widget.cart.setIsOrdered();
                widget.cart.clear();
              });
            },
      child: _isLoading
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
          : null,
    );
  }
}
