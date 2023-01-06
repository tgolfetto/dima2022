import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final TextOverflow? textOverflow;
  const TitleText(
      {Key? key,
      required this.text,
      this.fontSize = 18,
      this.textOverflow,
      required this.color,
      this.fontWeight = FontWeight.w900})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: TextAlign.center,
        overflow: textOverflow ?? TextOverflow.visible,
        style: TextStyle(
          fontFamily: 'Raleway',
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        ));
  }
}
