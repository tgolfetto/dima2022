import 'package:dima2022/view/homepage_screen.dart';
import 'package:dima2022/view/widgets/sidebar_widgets/filter.dart';
import 'package:dima2022/view/widgets/sidebar_widgets/pdp.dart';
import 'package:dima2022/view_models/content_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideBar extends StatefulWidget {
  SideBar({super.key});

  @override
  SideBarState createState() => SideBarState();
}

class SideBarState extends State<SideBar> {
  Widget _siderBarContent(int index) {
    print('sidebar $index');
    switch (index) {
      case Pdp.pageIndex:
        {
          return const Pdp();
        }
      default:
        {
          return const Filter();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = context.read<ContentViewModel>();
    return Drawer(
      child: Consumer<ContentViewModel>(
          builder: (context, content, _) =>
              _siderBarContent(content.sideBarIndex)),
      //),
    );
  }
}
