import 'dart:ui';
import 'package:flutter/material.dart';

class GlassRoundedContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin;
  final EdgeInsets itemPadding;
  final BorderRadius radius;
  final double opacity;

  GlassRoundedContainer({
    Key? key,
    required this.child,
    required this.margin,
    required this.itemPadding,
    required this.radius,
    required this.opacity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            padding: itemPadding,
            decoration: BoxDecoration(
              color: Colors.grey.shade100.withOpacity(opacity),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
