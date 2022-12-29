import 'package:dima2022/utils/size_config.dart';
import 'package:dima2022/view/custom_theme.dart';
import 'package:dima2022/view/widgets/product_line_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:layout/layout.dart';

import '../view_models/homepage_content_route.dart';
import 'grid_delegate.dart';
import './widgets/menu_widget/navigation_bottom_bar.dart';
import './widgets/menu_widget/navigation_side_bar.dart';
import './widgets/drawer_sheet.dart';

const kAlwaysDisplayDrawer = BreakpointValue(xs: false, md: true);

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState get createState => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  void onIndexSelect(newIndex) {
    setState(() {
      index = newIndex;
    });
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
          : const DrawerSheet(key: ValueKey('Drawer')),
      body: Stack(
        children: <Widget>[
          Container(
            color: CustomTheme.secondaryBackgroundColor,
            /*gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 196, 70, 231).withOpacity(0.5),
                  const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: const [0, 1],
              ),*/
          ),
          Row(
            children: [
              if (context.layout.breakpoint > LayoutBreakpoint.sm) ...[
                NavigationSideBar(
                  selectedIndex: index,
                  onIndexSelect: onIndexSelect,
                ),
                const VerticalDivider(width: 5),
              ],
              Expanded(
                  key: const ValueKey('HomePageBody'),
                  child: HomepageContentRoute().mainContent(index)),
              if (alwaysDisplayDrawer)
                const DrawerSheet(
                  key: ValueKey('Drawer'),
                ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: context.layout.breakpoint < LayoutBreakpoint.md
          ? NavigationBottomBar(
              selectedIndex: index,
              onIndexSelect: onIndexSelect,
            )
          : null,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: index < 2 ? _incrementCounter : null,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
