import 'package:flutter/material.dart';

import '../../../utils/size_config.dart';
import 'custom_theme.dart';

class CustomButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double height;
  final Gradient gradient;
  final VoidCallback? onPressed;
  final String? text;
  final IconData? icon;
  final bool transparent;
  final bool outline;
  final Widget? child;
  final double? fontSize;

  const CustomButton({
    super.key,
    required this.onPressed,
    this.child,
    this.text,
    this.icon,
    this.borderRadius,
    this.width,
    this.height = 44.0,
    this.fontSize,
    this.gradient = const LinearGradient(stops: [
      0,
      1
    ], colors: [
      Color(0xff0f877c),
      Color(0xff3e9f96),
    ]),
    required this.transparent,
    required this.outline,
  });

  @override
  Widget build(BuildContext context) {
    //final borderRadius = this.borderRadius ?? BorderRadius.circular(0);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: transparent == false && outline == false ? gradient : null,
        borderRadius: BorderRadius.circular(22),
        boxShadow: transparent == false && outline == false
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 4),
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
                textDirection: TextDirection.rtl,
                children: [
                  if (child != null) child!,
                  if (text != null)
                    Text(
                      text!,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 46, 46, 46),
                        fontSize: fontSize ?? 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (icon != null)
                    Icon(
                      icon,
                      size: fontSize != null ? fontSize! + 4 : 20,
                      color: const Color.fromARGB(255, 132, 132, 132),
                    ),
                ],
              ),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: !outline
                  ? ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenHeight(30)),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    )
                  : ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenHeight(30),
                      ),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: CustomTheme.secondaryColor,
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(22)),
                      textStyle: TextStyle(
                          fontSize: getProportionateScreenHeight(16),
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.bold),
                    ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (child != null) child!,
                  if (text != null)
                    Text(
                      text!,
                      style: TextStyle(
                        color: outline
                            ? const Color.fromARGB(255, 72, 72, 72)
                            : Colors.white,
                        fontSize: fontSize ?? 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (icon != null)
                    Row(
                      children: [
                        const SizedBox(width: 5),
                        Icon(
                          icon,
                          size: fontSize != null ? fontSize! + 4 : 20,
                          color: outline
                              ? CustomTheme.secondaryColor
                              : Colors.white,
                        ),
                      ],
                    ),
                ],
              ),
            ),
    );
  }
}
