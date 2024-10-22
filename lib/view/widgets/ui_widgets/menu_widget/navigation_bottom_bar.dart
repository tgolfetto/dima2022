import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/size_config.dart';
import '../../../../view_models/content_view_models/content_view_model.dart';
import '../../../../view_models/user_view_models/user_view_model.dart';
import '../../common/custom_theme.dart';
import '../glass_rounded_container.dart';
import './menu_bar_item.dart';

class NavigationBottomBar extends StatelessWidget {
  final int selectedIndex;

  const NavigationBottomBar({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Menu(
      currentIndex: selectedIndex,
      items: Provider.of<UserViewModel>(context).isClerk ? clerkItems : items,
    );
  }
}

class Menu extends StatelessWidget {
  const Menu({
    Key? key,
    required this.items,
    this.currentIndex = 0,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedColorOpacity,
    this.itemShape = const StadiumBorder(),
    this.margin,
    this.itemPadding = const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOutQuint,
  }) : super(key: key);

  final List<MenuBarItem> items;
  final int currentIndex;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? selectedColorOpacity;
  final ShapeBorder itemShape;
  final EdgeInsets? margin;
  final EdgeInsets itemPadding;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    SizeConfig().init(context);
    double width = MediaQuery.of(context).size.width;
    double yourMargin = (width * 0.09);

    final content = context.read<ContentViewModel>();
    return GlassRoundedContainer(
      margin: EdgeInsets.symmetric(
          vertical: getProportionateScreenWidth(CustomTheme.smallPadding),
          horizontal: yourMargin),
      itemPadding: EdgeInsets.symmetric(
          vertical: getProportionateScreenHeight(CustomTheme.spacePadding),
          horizontal: yourMargin * 0.5),
      radius: BorderRadius.circular(30.0),
      opacity: 0.5,
      enableBorder: false,
      enableShadow: true,
      child: Row(
        mainAxisAlignment: items.length <= 2
            ? MainAxisAlignment.spaceEvenly
            : MainAxisAlignment.spaceBetween,
        children: [
          for (final item in items)
            TweenAnimationBuilder<double>(
              tween: Tween(
                end: items.indexOf(item) == currentIndex ? 1.0 : 0.0,
              ),
              curve: curve,
              duration: duration,
              builder: (context, t, _) {
                final selectedColor = item.selectedColor ??
                    selectedItemColor ??
                    theme.primaryColor;

                final unselectedColor = item.unselectedColor ??
                    unselectedItemColor ??
                    theme.iconTheme.color;

                return Material(
                  color: Color.lerp(
                      selectedColor.withOpacity(0.0),
                      selectedColor.withOpacity(selectedColorOpacity ?? 0.1),
                      t),
                  shape: itemShape,
                  child: InkWell(
                    key: Key('menuIcon${items.indexOf(item)}'),
                    onTap: () {
                      content.updateMainContentIndex(items.indexOf(item));
                    },
                    customBorder: itemShape,
                    focusColor: selectedColor.withOpacity(0.1),
                    highlightColor: selectedColor.withOpacity(0.1),
                    splashColor: selectedColor.withOpacity(0.1),
                    hoverColor: selectedColor.withOpacity(0.1),
                    child: Padding(
                      padding: itemPadding -
                          (Directionality.of(context) == TextDirection.ltr
                              ? EdgeInsets.only(right: itemPadding.right * t)
                              : EdgeInsets.only(left: itemPadding.left * t)),
                      child: Row(
                        children: [
                          IconTheme(
                            data: IconThemeData(
                              color:
                                  Color.lerp(unselectedColor, selectedColor, t),
                              size: 24,
                            ),
                            child: items.indexOf(item) == currentIndex
                                ? item.activeIcon ?? item.icon
                                : item.icon,
                          ),
                          ClipRect(
                            clipBehavior: Clip.antiAlias,
                            child: SizedBox(
                              height: 20,
                              child: Align(
                                alignment: const Alignment(-0.2, 0.0),
                                widthFactor: t,
                                child: Padding(
                                  padding: Directionality.of(context) ==
                                          TextDirection.ltr
                                      ? EdgeInsets.only(
                                          left: itemPadding.left / 2,
                                          right: itemPadding.right)
                                      : EdgeInsets.only(
                                          left: itemPadding.left,
                                          right: itemPadding.right / 2),
                                  child: DefaultTextStyle(
                                    style: TextStyle(
                                      color: Color.lerp(
                                          selectedColor.withOpacity(0.0),
                                          selectedColor,
                                          t),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    child: item.title,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
