import 'package:flutter/material.dart';

import '../common/title_text.dart';

class CustomContainer extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final Color textColor;
  final double textSize;
  final Color containerColor;
  final double borderRadius;

  const CustomContainer(
      {super.key,
      this.width = 30,
      this.height = 30,
      this.text = '',
      this.textColor = Colors.white,
      this.textSize = 13,
      this.containerColor = const Color.fromARGB(200, 0, 150, 136),
      this.borderRadius = 10});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(borderRadius)),
      child: TitleText(
        color: textColor,
        text: text,
        fontSize: textSize,
      ),
    );
  }
}
