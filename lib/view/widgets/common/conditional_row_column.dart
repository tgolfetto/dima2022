import 'package:flutter/material.dart';
import 'package:layout/layout.dart';

class ConditionalRowColumn extends StatelessWidget {
  final List<Widget> children;
  final double screenWidth;
  final double screenHeight;

  const ConditionalRowColumn({
    Key? key,
    required this.children,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (context.layout.breakpoint == LayoutBreakpoint.sm &&
            screenWidth / screenHeight > 1) {
          return Row(
              crossAxisAlignment: CrossAxisAlignment.start, children: children);
        } else {
          return Column(children: children);
        }
      },
    );
  }
}
