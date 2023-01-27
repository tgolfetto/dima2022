import 'package:flutter/material.dart';
import 'package:layout/layout.dart';

import '../../../utils/size_config.dart';
import '../../../view_models/content_view_models/content_view_model.dart';
import '../ui_widgets/glass_rounded_container.dart';
import 'custom_button.dart';

class CloseCustomButtom extends StatelessWidget {
  const CloseCustomButtom({
    Key? key,
    required this.context,
    required this.content,
    required this.sizeWidth,
    required this.sideHeight,
    required this.onPressed,
  }) : super(key: key);

  final BuildContext context;

  final ContentViewModel content;
  final double sizeWidth;
  final double sideHeight;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var marginWidth = getProportionateScreenWidth(10, parentWidth: sizeWidth);
    var marginHeight = context.layout.breakpoint > LayoutBreakpoint.sm
        ? getProportionateScreenWidth(10, parentWidth: sizeWidth)
        : getProportionateScreenHeight(10, parentHeight: sideHeight) +
            MediaQuery.of(context).padding.top;

    return GlassRoundedContainer(
      margin: EdgeInsets.symmetric(
          vertical: marginHeight,
          horizontal: marginWidth / marginHeight * marginHeight),
      itemPadding: const EdgeInsets.symmetric(horizontal: 5),
      radius: BorderRadius.circular(20.0),
      opacity: 0.75,
      enableShadow: false,
      enableBorder: false,
      child: CustomButton(
        transparent: true,
        outline: false,
        icon: Icons.close,
        text: 'Close',
        onPressed: onPressed,
      ),
    );
  }
}
