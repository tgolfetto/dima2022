import 'package:dima2022/utils/size_config.dart';
import 'package:dima2022/view/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';

import './glass_rounded_container.dart';
import './menu_bar_item.dart';

class NavigationSideBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onIndexSelect;

  const NavigationSideBar({
    Key? key,
    required this.selectedIndex,
    required this.onIndexSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuSide(
      currentIndex: selectedIndex,
      onTap: onIndexSelect,
      items: items,
    );
  }
}

class MenuSide extends StatelessWidget {
  MenuSide({
    Key? key,
    required this.items,
    this.currentIndex = 0,
    this.onTap,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedColorOpacity,
    this.itemShape = const StadiumBorder(),
    this.margin = const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    this.itemPadding = const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.linear,
  }) : super(key: key);

  final List<MenuBarItem> items;
  final int currentIndex;
  final Function(int)? onTap;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? selectedColorOpacity;
  final ShapeBorder itemShape;
  final EdgeInsets margin;
  final EdgeInsets itemPadding;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassRoundedContainer(
      margin: margin,
      itemPadding: itemPadding,
      radius: BorderRadius.circular(30.0),
      opacity: 0.25,
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
                    onTap: () => onTap?.call(items.indexOf(item)),
                    customBorder: itemShape,
                    focusColor: _selectedColor.withOpacity(0.1),
                    highlightColor: _selectedColor.withOpacity(0.1),
                    splashColor: _selectedColor.withOpacity(0.1),
                    hoverColor: _selectedColor.withOpacity(0.1),
                    child: Container(
                      width: context.layout.breakpoint < LayoutBreakpoint.lg
                          ? getProportionateScreenWidth(27)
                          : getProportionateScreenWidth(60),
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(
                              CustomTheme.spacePadding),
                          vertical: getProportionateScreenHeight(
                              CustomTheme.spacePadding)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                      IconTheme(
                      data: IconThemeData(
                      color: Color.lerp(
                          _unselectedColor, _selectedColor, t),
                      size: getProportionateScreenHeight(40),
                    ),
                    child: items.indexOf(item) == currentIndex
                        ? item.activeIcon ?? item.icon
                        : item.icon,
                  ),
                  context.layout.breakpoint < LayoutBreakpoint.lg
                      ? const Spacer()
                      : Align(
                      alignment: Alignment.center,
                      widthFactor: t,
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: CustomTheme.spacePadding),
                          child: DefaultTextStyle(
                      style: TextStyle(
                      color: Color.lerp(
                          _selectedColor.withOpacity(0.0),
                      _selectedColor,
                      t),
                  fontWeight: FontWeight.bold,
                  fontSize: getProportionateScreenHeight(16),
                ),
                child: item.title,
                )),
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
