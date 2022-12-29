import 'package:dima2022/view/custom_theme.dart';
import 'package:dima2022/view/widgets/homepage_widgets/barcode_scanner.dart';
import 'package:dima2022/view/widgets/homepage_widgets/plp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:provider/provider.dart';

import '../view_models/content_view_model.dart';
import './widgets/drawer_sheet.dart';
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

  Widget _maincontent(int index){
    switch (index) {
      case 1:
        {
          return BarcodeScannerWidget((String code) {
            _barcodeScanned = code;
            if (kDebugMode) {
              print(_barcodeScanned);
            }
            /// @TODO: show the product of the related barcode
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
      default:
        {
          return const Plp();
          /// @TODO: show list of products
        }
    }
  }

  ElevatedButton get _cartButton {
    return ElevatedButton(
      style: CustomTheme.buttonStyleIcon,
      onPressed: () => {
        /// TODO: Open cart
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
        actions: [_cartButton],
        backgroundColor: CustomTheme.backgroundColor,
      ),
      endDrawer: alwaysDisplayDrawer
          ? null
          : DrawerSheet(key: const ValueKey('Drawer')),
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
                          _maincontent(content.mainContentIndex)),
              ),
              if (alwaysDisplayDrawer)
                DrawerSheet(
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