import 'package:flutter/material.dart';
import 'package:layout/layout.dart';

import '../../../utils/size_config.dart';

class CustomButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double height;
  final Gradient gradient;
  final VoidCallback? onPressed;
  final String? text;
  final IconData? icon;
  final bool transparent;
  final Widget? child;

  const CustomButton({
    required this.onPressed,
    this.child,
    this.text,
    this.icon,
    this.borderRadius,
    this.width,
    this.height = 44.0,
    this.gradient = const LinearGradient(stops: [
      0,
      1
    ], colors: [
      Color(0xff0f877c),
      Color(0xff3e9f96),
    ]),
    required this.transparent,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(0);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: transparent == false ? gradient : null,
        borderRadius: BorderRadius.circular(22),
        boxShadow: transparent == false
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: Offset(0, 4),
                  blurRadius: 4,
                ),
              ]
            : null,
      ),
      child: transparent
          ? TextButton(
              onPressed: onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (child != null) child!,
                  if (text != null)
                    Text(
                      text!,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 46, 46, 46),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (icon != null)
                    Icon(
                      icon,
                      color: Color.fromARGB(255, 132, 132, 132),
                    ),
                ],
              ),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenHeight(30)),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (child != null) child!,
                  if (text != null)
                    Text(
                      text!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (icon != null)
                    Icon(
                      icon,
                      color: Colors.white,
                    ),
                ],
              ),
            ),
    );
  }
}
