import 'package:dima2022/utils/constants.dart';
import 'package:dima2022/view/widgets/sidebar_widgets/profile_side/user_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:provider/provider.dart';

import '../../../../utils/size_config.dart';

import '../../../../view_models/cart_view_models/cart_view_model.dart';
import '../../../../view_models/content_view_model.dart';
import '../../../../view_models/user_view_models/user_view_model.dart';
import '../../../custom_theme.dart';
import '../../sidebar_widgets/cart/cart_side.dart';
import '../glass_rounded_container.dart';
import 'badge.dart';
import 'user_avatar.dart';

class WindowBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final content = context.read<ContentViewModel>();
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    SizeConfig().init(context);
    var marginWidth = getProportionateScreenWidth(10);
    var marginHeight = getProportionateScreenHeight(10);
    return Container(
      padding: EdgeInsets.only(
          top: marginHeight + MediaQuery.of(context).padding.top,
          left: marginWidth / marginHeight * marginHeight,
          right: marginWidth / marginHeight * marginHeight),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GlassRoundedContainer(
                  margin: const EdgeInsets.all(0),
                  itemPadding: EdgeInsets.symmetric(
                      vertical: marginHeight, horizontal: marginWidth),
                  radius: BorderRadius.circular(20.0),
                  opacity: 0.4,
                  enableShadow: false,
                  enableBorder: true,
                  child: SizedBox(
                    child: Row(
                      children: [
                        Consumer<CartViewModel>(
                          builder: (_, cart, ch) => Badge(
                            value: cart.itemCount.toString(),
                            color: CustomTheme.secondaryColor,
                            child: ch!,
                          ),
                          child: IconButton(
                            iconSize: 30,
                            icon: const Icon(
                              Icons.shopping_cart,
                            ),
                            onPressed: () {
                              // mostra nella side
                              if (context.layout.breakpoint <
                                  LayoutBreakpoint.md) {
                                content
                                    .updateMainContentIndex(CartSide.pageIndex);
                              } else {
                                content.updateSideBarIndex(CartSide.pageIndex);
                              }
                            },
                          ),
                        ),
                        const Gutter(),
                        UserAvatar(
                            onPressed: () {
                              if (context.layout.breakpoint <
                                  LayoutBreakpoint.md) {
                                content.updateMainContentIndex(
                                    UserInputForm.pageIndex);
                              } else {
                                content.updateSideBarIndex(
                                    UserInputForm.pageIndex);
                              }
                            },
                            avatarUrl: Provider.of<UserViewModel>(context)
                                .profileImageUrl),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, double.infinity);
}
