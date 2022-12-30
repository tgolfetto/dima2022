import 'package:dima2022/view/custom_theme.dart';
import 'package:dima2022/view/widgets/homepage_widgets/barcode_scanner.dart';
import 'package:dima2022/view/widgets/sidebar_widgets/cart.dart';
import 'package:dima2022/view/widgets/homepage_widgets/plp.dart';
import 'package:dima2022/view/widgets/sidebar_widgets/filter.dart';
import 'package:dima2022/view/widgets/sidebar_widgets/pdp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:provider/provider.dart';

import '../view_models/content_view_model.dart';
import './widgets/side_bar.dart';
import './widgets/menu_widget/navigation_bottom_bar.dart';
import './widgets/menu_widget/navigation_side_bar.dart';

const kAlwaysDisplayDrawer = BreakpointValue(xs: false, md: true);

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late String _barcodeScanned;

  Widget _maincontent(BuildContext context, int index) {
    switch (index) {
      case BarcodeScannerWidget.pageIndex:
        {
          return BarcodeScannerWidget((String code) {
            _barcodeScanned = code;
            if (kDebugMode) {
              print(_barcodeScanned);
            }
            final content = context.read<ContentViewModel>();
            content.updateProductId(code);
            if (context.layout.breakpoint < LayoutBreakpoint.lg) {
              content.updateMainContentIndex(Pdp.pageIndex);
            } else {
              content.updateSideBarIndex(Pdp.pageIndex);
            }
          });
        }
      case 2:
        {
          return const Text('Dressing room');

          /// @TODO: show dressing room widget
        }
      case 3:
        {
          return const Text('Profile');

          /// @TODO: show profile widget
        }
      case Filter.pageIndex:
        {
          return const Filter();
        }
      case Pdp.pageIndex:
        {
          return const Pdp();
        }
      case CartWidget.pageIndex:
        {
          return const CartWidget();
        }
      default:
        {
          return const Plp();
        }
    }
  }

  ElevatedButton _cartButton(BuildContext context) {
    final content = context.read<ContentViewModel>();
    return ElevatedButton(
      style: CustomTheme.buttonStyleIcon,
      onPressed: () {
        if (context.layout.breakpoint < LayoutBreakpoint.md) {
          content.updateMainContentIndex(CartWidget.pageIndex);
        } else {
          content.updateSideBarIndex(CartWidget.pageIndex);
        }
      },
      child: const Icon(Icons.shopping_cart),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = context.read<ContentViewModel>();
    final alwaysDisplayDrawer = context.layout.breakpoint > LayoutBreakpoint.sm;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: CustomTheme.primaryColor),
        title: const Text(CustomTheme.appTitle,
            style: TextStyle(color: Colors.black)),
        actions: [_cartButton(context)],
        backgroundColor: CustomTheme.backgroundColor,
      ),
      endDrawer: alwaysDisplayDrawer
          ? null
          : SideBar(key: const ValueKey('Drawer')),
      body: Stack(
        children: <Widget>[
          Container(
            color: CustomTheme.secondaryBackgroundColor,
          ),
          Row(
            children: [
              if (context.layout.breakpoint > LayoutBreakpoint.sm) ...[
                NavigationSideBar(
                  selectedIndex: content.mainContentIndex,
                ),
                const VerticalDivider(width: 5),
              ],
              Expanded(
                key: const ValueKey('HomePageBody'),
                child: Consumer<ContentViewModel>(
                    builder: (context, content, _) =>
                        _maincontent(context, content.mainContentIndex)),
              ),
              if (alwaysDisplayDrawer)
                SideBar(
                  key: const ValueKey('Drawer'),
                ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: context.layout.breakpoint < LayoutBreakpoint.md
          ? NavigationBottomBar(
              selectedIndex: content.mainContentIndex,
            )
          : null,
    );
  }
}