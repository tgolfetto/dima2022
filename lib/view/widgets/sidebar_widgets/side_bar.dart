import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/size_config.dart';

import '../../../view_models/content_view_models/content_view_model.dart';
import '../common/animated_resize.dart';
import '../ui_widgets/glass_rounded_container.dart';
import 'cart/cart_side.dart';
import 'filter.dart';
import 'pdp_side/pdp.dart';

import 'order_side/order_side.dart';
import 'profile_side/user_input_widget.dart';
import 'requests_side/request_side.dart';
import 'scanner_instructions.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  SideBarState createState() => SideBarState();
}

class SideBarState extends State<SideBar> {
  Widget _siderBarContent(int index) {
    switch (index) {
      case Pdp.pageIndex:
        {
          return const Pdp();
        }
      case CartSide.pageIndex:
        {
          return const CartSide();
        }
      case UserInputForm.pageIndex:
        {
          return const UserInputForm();
        }
      case RequestSide.pageIndex:
        {
          return const RequestSide();
        }
      case ScannerInstructions.pageIndex:
        {
          return const ScannerInstructions();
        }
      case OrderSide.pageIndex:
        {
          return const OrderSide();
        }
      default:
        {
          return const Filter();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var marginWidth = getProportionateScreenWidth(10);
    var marginHeight = getProportionateScreenHeight(20);
    return AnimatedResize(
      child: GlassRoundedContainer(
        margin: EdgeInsets.symmetric(
            vertical: marginHeight,
            horizontal: marginWidth / marginHeight * marginHeight),
        itemPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        // const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
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
