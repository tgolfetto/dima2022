import 'package:dima2022/view/homepage_screen.dart';
import 'package:dima2022/view/widgets/sidebar_widgets/cart.dart';
import 'package:dima2022/view/widgets/sidebar_widgets/cart/cart_side.dart';
import 'package:dima2022/view/widgets/sidebar_widgets/filter.dart';
import 'package:dima2022/view/widgets/sidebar_widgets/pdp.dart';
import 'package:dima2022/view/widgets/sidebar_widgets/profile_side/user_input_widget.dart';
import 'package:dima2022/view_models/content_view_models/content_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/size_config.dart';
import '../common/animated_resize.dart';
import '../ui_widgets/glass_rounded_container.dart';

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
      case CartSide.pageIndex:
        {
          return CartSide();
        }
      case UserInputForm.pageIndex:
        {
          return const UserInputForm();
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

    SizeConfig().init(context);
    var marginWidth = getProportionateScreenWidth(10);
    var marginHeight = getProportionateScreenHeight(20);
    return AnimatedResize(
      child: GlassRoundedContainer(
        margin: EdgeInsets.symmetric(
            vertical: marginHeight / marginHeight * marginHeight,
            horizontal: marginWidth / marginHeight * marginHeight),
        itemPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        radius: BorderRadius.circular(20.0),
        opacity: 0.8,
        enableBorder: false,
        enableShadow: true,
        child: Consumer<ContentViewModel>(
            builder: (context, content, _) =>
                _siderBarContent(content.sideBarIndex)),
      ),
    );
  }
}
