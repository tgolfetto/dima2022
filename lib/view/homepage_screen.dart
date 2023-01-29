import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:layout/layout.dart';
import 'package:provider/provider.dart';

import '../view_models/content_view_models/content_view_model.dart';
import '../view_models/position_view_models/position_view_model.dart';
import '../view_models/product_view_models/product_view_model.dart';
import '../view_models/product_view_models/products_view_model.dart';
import '../view_models/user_view_models/user_view_model.dart';
import 'widgets/common/animated_circular_progress_indicator.dart';
import 'widgets/common/custom_theme.dart';
import 'widgets/homepage_widgets/barcode_scanner.dart';
import 'widgets/homepage_widgets/orders/orders_page.dart';
import 'widgets/homepage_widgets/plp/plp.dart';
import 'widgets/homepage_widgets/requests/requests_page.dart';
import 'widgets/sidebar_widgets/cart/cart_side.dart';
import 'widgets/sidebar_widgets/filter.dart';
import 'widgets/sidebar_widgets/order_side/order_side.dart';
import 'widgets/sidebar_widgets/pdp_side/pdp.dart';
import 'widgets/sidebar_widgets/profile_side/user_input_widget.dart';
import 'widgets/sidebar_widgets/requests_side/request_side.dart';
import 'widgets/sidebar_widgets/scanner_instructions.dart';
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

  late String _barcodeScanned;

  Widget _maincontent(BuildContext context, int index) {
    final content = context.read<ContentViewModel>();
    switch (index) {
      case BarcodeScannerWidget.pageIndex:
        {
          if (content.sideBarIndex != CartSide.pageIndex &&
              content.sideBarIndex != UserInputForm.pageIndex) {
            WidgetsBinding.instance.addPostFrameCallback((_) =>
                content.updateSideBarIndex(ScannerInstructions.pageIndex));
          }
          return BarcodeScannerWidget((String code) {
            _barcodeScanned = code;
            try {
              final content = context.read<ContentViewModel>();
              ProductViewModel loadedProduct = Provider.of<ProductListViewModel>(
                context,
                listen: false,
              ).findById(code);
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => content.updateProductId(code));
              if (context.layout.breakpoint < LayoutBreakpoint.md) {
                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => content.updateMainContentIndex(Pdp.pageIndex));
              } else {
                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => content.updateSideBarIndex(Pdp.pageIndex));
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
          if (content.sideBarIndex != CartSide.pageIndex &&
              content.sideBarIndex != UserInputForm.pageIndex) {
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => content.updateSideBarIndex(RequestSide.pageIndex));
          }
          return const RequestPage();
        }
      case 3:
        {
          if (content.sideBarIndex != CartSide.pageIndex &&
              content.sideBarIndex != UserInputForm.pageIndex) {
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => content.updateSideBarIndex(OrderSide.pageIndex));
          }
          return const OrdersPage();
        }
      case Filter.pageIndex:
        {
          if (context.layout.breakpoint < LayoutBreakpoint.md) {
            return const Filter();
          } else {
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => content.updateMainContentIndex(Plp.pageIndex));
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => content.updateSideBarIndex(Filter.pageIndex));
            return const Plp();
          }
        }
      case Pdp.pageIndex:
        {
          if (context.layout.breakpoint < LayoutBreakpoint.md) {
            return const Pdp();
          } else {
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => content.updateMainContentIndex(Plp.pageIndex));
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => content.updateSideBarIndex(Pdp.pageIndex));
            return const Plp();
          }
        }
      case CartSide.pageIndex:
        {
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => content.updateSideBarIndex(CartSide.pageIndex));
          if (context.layout.breakpoint < LayoutBreakpoint.md) {
            return const CartSide();
          } else {
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => content.updateMainContentIndex(Plp.pageIndex));
            return const Plp();
          }
        }
      case UserInputForm.pageIndex:
        {
          if (context.layout.breakpoint < LayoutBreakpoint.md) {
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => content.updateSideBarIndex(UserInputForm.pageIndex));
            return const UserInputForm();
          } else {
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => content.updateSideBarIndex(UserInputForm.pageIndex));
            return const Plp();
          }
        }
      default:
        {
          if (context.layout.breakpoint < LayoutBreakpoint.md) {
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => content.updateSideBarIndex(Filter.pageIndex));
          }else{
            if(content.sideBarIndex == RequestSide.pageIndex || content.sideBarIndex == OrderSide.pageIndex || content.sideBarIndex == ScannerInstructions.pageIndex){
              WidgetsBinding.instance.addPostFrameCallback(
                      (_) => content.updateSideBarIndex(Filter.pageIndex));
            }
          }
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
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final displaySide = context.layout.breakpoint > LayoutBreakpoint.sm;

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

                Stack(
                  children: [
                    LayoutBuilder(builder: (context, constraints) {
                      return Column(
                        children: [
                          if (context.layout.breakpoint >= LayoutBreakpoint.md)
                            const WindowBar(),
                          Flexible(
                            child: Row(
                              children: [
                                if (context.layout.breakpoint >=
                                    LayoutBreakpoint.md) ...[
                                  Consumer<ContentViewModel>(
                                    builder: (context, content, _) =>
                                        NavigationSideBar(
                                      selectedIndex: content.mainContentIndex,
                                    ),
                                  ),
                                ],
                                Flexible(
                                  child: Consumer<ContentViewModel>(
                                    builder: (context, content, _) =>
                                        _maincontent(
                                      context,
                                      content.mainContentIndex,
                                    ),
                                  ),
                                ),
                                if (displaySide) const SideBar(),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                    if (context.layout.breakpoint < LayoutBreakpoint.md)
                      const Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: WindowBar(),
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
                                .withOpacity(0.13),
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
