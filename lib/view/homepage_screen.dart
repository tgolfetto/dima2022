import 'package:dima2022/view/custom_theme.dart';
import 'package:dima2022/view/widgets/homepage_widgets/barcode_scanner.dart';
import 'package:dima2022/view/widgets/homepage_widgets/orders_page.dart';
import 'package:dima2022/view/widgets/homepage_widgets/requests.dart';
import 'package:dima2022/view/widgets/sidebar_widgets/cart.dart';
import 'package:dima2022/view/widgets/homepage_widgets/plp.dart';
import 'package:dima2022/view/widgets/sidebar_widgets/cart/cart_side.dart';
import 'package:dima2022/view/widgets/sidebar_widgets/filter.dart';
import 'package:dima2022/view/widgets/sidebar_widgets/pdp.dart';
import 'package:dima2022/view/widgets/sidebar_widgets/profile_side/user_input_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:provider/provider.dart';

import '../view_models/content_view_model.dart';
import '../view_models/user_view_models/user_view_model.dart';
import 'widgets/common/animated_circular_progress_indicator.dart';
import 'widgets/sidebar_widgets/side_bar.dart';

import 'widgets/ui_widgets/appbar_widget/windows_bar.dart';
import 'widgets/ui_widgets/menu_widget/navigation_bottom_bar.dart';
import 'widgets/ui_widgets/menu_widget/navigation_side_bar.dart';

const kAlwaysDisplayDrawer = BreakpointValue(xs: false, md: true);

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  var _isInit = true;
  var _isLoading = false;
  var userViewModel;

  late String _barcodeScanned;

  Widget _maincontent(BuildContext context, int index) {
    switch (index) {
      case BarcodeScannerWidget.pageIndex:
        {
          return BarcodeScannerWidget((String code) {
            _barcodeScanned = code;
            try {
              final content = context.read<ContentViewModel>();
              content.updateProductId(code);
              if (context.layout.breakpoint < LayoutBreakpoint.md) {
                content.updateMainContentIndex(Pdp.pageIndex);
              } else {
                content.updateSideBarIndex(Pdp.pageIndex);
              }
            } catch (e) {
              if (kDebugMode) {
                print('$e \n No item with barcode $_barcodeScanned found');
              }
            }
          });
        }
      case 2:
        {
          return const RequestPage();
        }
      case 3:
        {
          return const OrdersPage();
        }
      case Filter.pageIndex:
        {
          return const Filter();
        }
      case Pdp.pageIndex:
        {
          return const Pdp();
        }
      case CartSide.pageIndex:
        {
          return CartSide();
        }
      default:
        {
          return const Plp();
        }
    }
  }

  // ElevatedButton _cartButton(BuildContext context) {
  //   final content = context.read<ContentViewModel>();
  //   return ElevatedButton(
  //     style: CustomTheme.buttonStyleIcon,
  //     onPressed: () {
  //       if (context.layout.breakpoint < LayoutBreakpoint.md) {
  //         content.updateMainContentIndex(CartSide.pageIndex);
  //       } else {
  //         content.updateSideBarIndex(CartSide.pageIndex);
  //       }
  //     },
  //     child: const Icon(Icons.shopping_cart),
  //   );
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<UserViewModel>(context).getUser().then((_) {
        setState(() {
          userViewModel = Provider.of<UserViewModel>(context, listen: false);

          _isLoading = false;
        });
      });
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final content = context.read<ContentViewModel>();
    final alwaysDisplayDrawer = context.layout.breakpoint > LayoutBreakpoint.sm;
    return _isLoading
        ? const Center(
            child: AnimatedCircularProgressIndicator(),
          )
        : Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            appBar: null,

            // AppBar(
            //   iconTheme: IconThemeData(color: CustomTheme.primaryColor),
            //   title: const Text(CustomTheme.appTitle,
            //       style: TextStyle(color: Colors.black)),
            //   actions: [_cartButton(context)],
            //   backgroundColor: CustomTheme.backgroundColor,
            // ),

            // endDrawer:
            //     alwaysDisplayDrawer ? null : SideBar(key: const ValueKey('Drawer')),
            body: Stack(
              children: <Widget>[
                Container(
                  color: CustomTheme.secondaryBackgroundColor,
                ),
                Column(
                  children: [
                    WindowBar(userViewModel: userViewModel),
                    Flexible(
                      child: Row(
                        children: [
                          if (context.layout.breakpoint >
                              LayoutBreakpoint.sm) ...[
                            Consumer<ContentViewModel>(
                                builder: (context, content, _) =>
                                    NavigationSideBar(
                                      selectedIndex: content.mainContentIndex,
                                    )),
                            //const VerticalDivider(width: 5),
                          ],
                          Expanded(
                            key: const ValueKey('HomePageBody'),
                            child: Consumer<ContentViewModel>(
                                builder: (context, content, _) => _maincontent(
                                    context, content.mainContentIndex)),
                          ),
                          if (alwaysDisplayDrawer) SideBar(),
                          // SideBar(
                          //   key: const ValueKey('Drawer'),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Add the vignette container here
                if (context.layout.breakpoint < LayoutBreakpoint.md)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            const Color.fromARGB(255, 106, 106, 106)
                                .withOpacity(0.2),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            bottomNavigationBar: context.layout.breakpoint < LayoutBreakpoint.md
                ? Consumer<ContentViewModel>(
                    builder: (context, content, _) => NavigationBottomBar(
                      selectedIndex: content.mainContentIndex,
                    ),
                  )
                : null,
          );
  }
}
