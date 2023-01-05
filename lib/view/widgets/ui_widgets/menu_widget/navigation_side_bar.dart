import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/size_config.dart';
import '../../../../view_models/content_view_models/content_view_model.dart';
import '../glass_rounded_container.dart';
import './menu_bar_item.dart';

class NavigationSideBar extends StatelessWidget {
  final int selectedIndex;

  const NavigationSideBar({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuSide(
      currentIndex: selectedIndex,
      items: items,
    );
  }
}

class MenuSide extends StatelessWidget {
  MenuSide({
    Key? key,
    required this.items,
    this.currentIndex = 0,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedColorOpacity,
    this.margin = const EdgeInsets.symmetric(vertical: 100, horizontal: 30),
    this.itemPadding = const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.linear,
  }) : super(key: key);

  final List<MenuBarItem> items;
  final int currentIndex;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? selectedColorOpacity;
  final ShapeBorder itemShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(22),
  );
  final EdgeInsets margin;
  final EdgeInsets itemPadding;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = context.read<ContentViewModel>();
    SizeConfig().init(context);
    double marginWidth = getProportionateScreenWidth(30) > 30.0
        ? 30.0
        : getProportionateScreenWidth(30);
    double marginHeight = getProportionateScreenHeight(90) > 90.0
        ? 90.0
        : getProportionateScreenHeight(90);

    return GlassRoundedContainer(
      margin:
          EdgeInsets.symmetric(vertical: marginHeight, horizontal: marginWidth),
      itemPadding: itemPadding,
      radius: BorderRadius.circular(30.0),
      opacity: 0.25,
      enableBorder: true,
      enableShadow: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (final item in items)
            TweenAnimationBuilder<double>(
              tween: Tween(
                end: items.indexOf(item) == currentIndex ? 1.0 : 0.0,
              ),
              curve: curve,
              duration: duration,
              builder: (context, t, _) {
                final _selectedColor = item.selectedColor ??
                    selectedItemColor ??
                    theme.primaryColor;

                final _unselectedColor = item.unselectedColor ??
                    unselectedItemColor ??
                    theme.iconTheme.color;

                return Material(
                  color: Color.lerp(
                      _selectedColor.withOpacity(0.0),
                      _selectedColor.withOpacity(selectedColorOpacity ?? 0.1),
                      t),
                  shape: itemShape,
                  child: InkWell(
                    onTap: () =>
                        content.updateMainContentIndex(items.indexOf(item)),
                    customBorder: itemShape,
                    focusColor: _selectedColor.withOpacity(0.1),
                    highlightColor: _selectedColor.withOpacity(0.1),
                    splashColor: _selectedColor.withOpacity(0.1),
                    hoverColor: _selectedColor.withOpacity(0.1),
                    child: Container(
                      width: 100,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconTheme(
                            data: IconThemeData(
                              color: Color.lerp(
                                  _unselectedColor, _selectedColor, t),
                              size: 40 * marginHeight * 0.01 > 40
                                  ? 40
                                  : 40 * marginHeight * 0.01,
                            ),
                            child: items.indexOf(item) == currentIndex
                                ? item.activeIcon ?? item.icon
                                : item.icon,
                          ),
                          SizedBox(
                            child: Align(
                              alignment: Alignment.center,
                              widthFactor: t,
                              child: DefaultTextStyle(
                                style: TextStyle(
                                  color: Color.lerp(
                                      _selectedColor.withOpacity(0.0),
                                      _selectedColor,
                                      t),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15 * marginHeight * 0.01 > 15
                                      ? 15
                                      : 15 * marginHeight * 0.01,
                                ),
                                child: item.title,
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
