import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:provider/provider.dart';

import '../../../../utils/size_config.dart';

import '../../../../view_models/cart_view_models/cart_view_model.dart';
import '../../../../view_models/content_view_models/content_view_model.dart';
import '../../../../view_models/user_view_models/user_view_model.dart';
import '../../common/custom_theme.dart';
import '../../sidebar_widgets/cart/cart_side.dart';
import '../../sidebar_widgets/profile_side/user_input_widget.dart';
import '../glass_rounded_container.dart';
import 'badge.dart';
import 'user_avatar.dart';

class WindowBar extends StatefulWidget with PreferredSizeWidget {
  const WindowBar({super.key});

  @override
  State<WindowBar> createState() => _WindowBarState();

  @override
  Size get preferredSize => throw UnimplementedError();
}

class _WindowBarState extends State<WindowBar> {
  @override
  Widget build(BuildContext context) {
    final UserViewModel userViewModel = Provider.of<UserViewModel>(context);

    final content = context.read<ContentViewModel>();
    // final theme = Theme.of(context);
    // final size = MediaQuery.of(context).size;
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
                  opacity: 0.75,
                  enableShadow: false,
                  enableBorder: true,
                  child: SizedBox(
                    child: Row(
                      children: [
                        if (!userViewModel.isClerk)
                          Row(
                            children: [
                              Consumer<CartViewModel>(
                                builder: (_, cart, ch) => Badge(
                                  value: cart.itemCount.toString(),
                                  color: CustomTheme.secondaryColor,
                                  child: ch!,
                                ),
                                child: IconButton(
                                  key: const Key('cartIconButton'),
                                  iconSize: 30,
                                  icon: const Icon(
                                    Icons.shopping_cart,
                                  ),
                                  onPressed: () {
                                    // mostra nella side
                                    if (context.layout.breakpoint <
                                        LayoutBreakpoint.md) {
                                      content.updateMainContentIndex(
                                          CartSide.pageIndex);
                                    } else {
                                      content.updateSideBarIndex(
                                          CartSide.pageIndex);
                                    }
                                  },
                                ),
                              ),
                              const Gutter(),
                            ],
                          ),
                        UserAvatar(
                          key: const Key('userIconButton'),
                          onPressed: () {
                            if (context.layout.breakpoint <
                                LayoutBreakpoint.md) {
                              content.updateMainContentIndex(
                                  UserInputForm.pageIndex);
                            } else {
                              content
                                  .updateSideBarIndex(UserInputForm.pageIndex);
                            }
                          },
                          avatarUrl: userViewModel.profileImageUrl,
                        ),
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

  Size get preferredSize => const Size(double.infinity, double.infinity);
}
