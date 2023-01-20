import 'dart:async';

import 'package:dima2022/view/custom_theme.dart';
import 'package:dima2022/view/widgets/homepage_widgets/barcode_scanner.dart';
import 'package:dima2022/view/widgets/homepage_widgets/orders_page.dart';
import 'package:dima2022/view/widgets/homepage_widgets/requests_page.dart';
import 'package:dima2022/view/widgets/homepage_widgets/plp.dart';
import 'package:dima2022/view/widgets/sidebar_widgets/cart/cart_side.dart';
import 'package:dima2022/view/widgets/sidebar_widgets/filter.dart';
import 'package:dima2022/view/widgets/sidebar_widgets/pdp.dart';
import 'package:dima2022/view/widgets/sidebar_widgets/requests_side/clerk_requests.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:layout/layout.dart';
import 'package:provider/provider.dart';

import '../utils/size_config.dart';
import '../view_models/content_view_models/content_view_model.dart';
import '../view_models/position_view_models/position_view_model.dart';
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
  //late UserViewModel userViewModel;

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
      case RequestPage.pageIndex:
        {
          // TODO non il massim
          final content = context.read<ContentViewModel>();
          content.updateSideBarIndex(RequestSide.pageIndex);
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

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<UserViewModel>(context).getUser().then((_) {
        setState(() {
          //userViewModel = Provider.of<UserViewModel>(context, listen: false);

          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final content = context.read<ContentViewModel>();
    final alwaysDisplayDrawer = context.layout.breakpoint > LayoutBreakpoint.sm;

    Provider.of<PositionViewModel>(context, listen: false)
        .listenLocation(context);

    return _isLoading
        ? const Center(
            child: AnimatedCircularProgressIndicator(),
          )
        : Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            appBar: null,
            body: Stack(
              children: <Widget>[
                Container(
                  color: CustomTheme.secondaryBackgroundColor,
                ),

                // Stack(
                //   children: [
                //     LayoutBuilder(builder: (context, constraints) {
                //       return
                Column(
                  children: [
                    WindowBar(),
                    Flexible(
                      child: Row(
                        children: [
                          if (context.layout.breakpoint >=
                              LayoutBreakpoint.md) ...[
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
                        ],
                      ),
                    ),
                  ],
                ),
                // }),
                //     Positioned(
                //       top: 0,
                //       left: 0,
                //       right: 0,
                //       child: WindowBar(userViewModel: userViewModel),
                //     ),
                //   ],
                // ),

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
                                .withOpacity(0.18),
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
