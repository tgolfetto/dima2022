import 'package:dima2022/view/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:layout/layout.dart';

import '../model_view/homepage_content_route.dart';
import 'grid_delegate.dart';
import './widgets/cart_item.dart';
import './widgets/menu_widget/navigation_bottom_bar.dart';
import './widgets/menu_widget/navigation_side_bar.dart';
import './widgets/drawer_sheet.dart';

const kAlwaysDisplayDrawer = BreakpointValue(xs: false, md: true);

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;

  void onIndexSelect(newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  ElevatedButton get _cartButton {
    return ElevatedButton(
      style: buttonStyle,
      onPressed: () => Modular.to.navigate('/cart'),
      child: const Icon(Icons.shopping_cart),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alwaysDisplayDrawer = context.layout.breakpoint > LayoutBreakpoint.sm;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(widget.title, style: TextStyle(color: Colors.black)),
        actions: [_cartButton],
      ),
      endDrawer:
          alwaysDisplayDrawer ? null : DrawerSheet(key: ValueKey('Drawer')),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 196, 70, 231).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0, 1],
              ),
            ),
          ),
          Row(
            children: [
              if (context.layout.breakpoint > LayoutBreakpoint.sm) ...[
                NavigationSideBar(
                  selectedIndex: index,
                  onIndexSelect: onIndexSelect,
                ),
                VerticalDivider(width: 5),
              ],
              Expanded(
                  key: ValueKey('HomePageBody'),
                  child: HomepageContentRoute().mainContent(index)),
              if (alwaysDisplayDrawer)
                DrawerSheet(
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

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double spacing = BreakpointValue(xs: 0.0, sm: 10.0).resolve(context);

    return Scrollbar(
      child: Container(
        //color: Theme.of(context).scaffoldBackgroundColor,
        child: CustomScrollView(
          slivers: [
            SliverGutter(),
            SliverToBoxAdapter(
              child: Margin(
                child: Text('Section Title'),
              ),
            ),
            SliverGutter(),
            SliverMargin(
              margin: context.layout.breakpoint == LayoutBreakpoint.xs
                  ? EdgeInsets.zero
                  : null,
              sliver: SliverGrid(
                delegate: SliverChildListDelegate.fixed(
                  List.generate(
                    100,
                    (index) => CardItem(index: index),
                  ),
                ),
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCountAndMainAxisExtent(
                  crossAxisCount: context.layout.value(
                    xs: 1,
                    sm: 2,
                    md: 2,
                    lg: 3,
                    xl: 4,
                  ),
                  mainAxisExtent: 60,
                  mainAxisSpacing: spacing,
                  crossAxisSpacing: spacing,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
