import 'package:flutter/material.dart';

import '../../common/custom_theme.dart';

class Badge extends StatelessWidget {
  const Badge({
    Key? key,
    required this.child,
    required this.value,
    this.color,
  }) : super(key: key);

  final Widget child;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 5,
          top: 5,
          child: int.parse(value) > 0
              ? Container(
                  padding: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    //borderRadius: BorderRadius.circular(8.0),
                    shape: BoxShape.circle,
                    color: color ?? CustomTheme.secondaryColor,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                )
              : Container(),
        ),
      ],
    );
  }
}
