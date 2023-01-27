import 'package:flutter/material.dart';
import 'package:layout/layout.dart';

class ScreenBuilder extends StatelessWidget {
  final Widget Function(
          BuildContext, BoxConstraints, double, double, bool, double, double)
      builder;

  const ScreenBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool tabletMode = context.layout.breakpoint >= LayoutBreakpoint.md;
    double additionalTopPadding = tabletMode ? 0 : 80;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        bool isKeyboardActive = MediaQuery.of(context).viewInsets.bottom > 0;
        double? screenWidth = constraints.maxWidth;
        double? sideHeight = constraints.maxHeight;
        final topPadding = isKeyboardActive
            ? MediaQuery.of(context).viewInsets.top
            : MediaQuery.of(context).padding.top + additionalTopPadding;
        final bottomPadding = isKeyboardActive
            ? MediaQuery.of(context).viewInsets.bottom
            : MediaQuery.of(context).padding.bottom;
        return builder(
          context,
          constraints,
          topPadding,
          bottomPadding,
          isKeyboardActive,
          screenWidth,
          sideHeight,
        );
      },
    );
  }
}
