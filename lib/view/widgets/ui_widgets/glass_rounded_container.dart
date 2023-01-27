import 'dart:ui';
import 'package:flutter/material.dart';

class GlassRoundedContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin;
  final EdgeInsets itemPadding;
  final BorderRadius radius;
  final double opacity;
  final bool enableShadow;
  final bool enableBorder;

  const GlassRoundedContainer({
    Key? key,
    required this.child,
    required this.margin,
    required this.itemPadding,
    required this.radius,
    required this.opacity,
    required this.enableShadow,
    required this.enableBorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: enableBorder
            ? Border.all(
                color: const Color.fromARGB(60, 150, 150, 150),
              )
            : null,
        borderRadius: radius,
        boxShadow: !enableShadow
            ? null
            : [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 119, 119, 119).withOpacity(0.2),
                  blurRadius: 8.0,
                  spreadRadius: 4.0,
                  offset: const Offset(4, 4),
                )
              ],
      ),
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
