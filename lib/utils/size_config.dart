import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData = const MediaQueryData();
  static double screenWidth = 0.0;
  static double screenHeight = 0.0;
  static double defaultSize = 0.0;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);

    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

double getProportionateScreenHeight(double inputHeight,
    {double? parentHeight}) {
  double screenHeight = parentHeight ?? SizeConfig.screenHeight;
  return (inputHeight / 812.0) * screenHeight;
}

double getProportionateScreenWidth(double inputWidth, {double? parentWidth}) {
  double screenWidth = parentWidth ?? SizeConfig.screenWidth;
  return (inputWidth / 375.0) * screenWidth;
}
