import 'package:flutter/material.dart';
import '../utils/size_config.dart';

class CustomTheme {
  static const String appTitle = 'My Shop App.';

  static Color primaryColor = Colors.black;
  static Color backgroundColor = Colors.white;
  static Color secondaryColor = Colors.teal;
  static Color accentColor = Colors.redAccent;
  static Color secondaryBackgroundColor = Colors.white60;

  static double spacePadding = 8.0;
  static double smallPadding = 12.0;
  static double mediumPadding = 24.0;
  static double bigPadding = 32.0;
  static double buttonPaddingV = 16.0;
  static double buttonPaddingH = 9.0;

  static ButtonStyle buttonStyleFill = ElevatedButton.styleFrom(
      backgroundColor: secondaryColor,
      foregroundColor: backgroundColor,
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenHeight(buttonPaddingV),
        //horizontal: getProportionateScreenWidth(buttonPaddingH)
      ),
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: secondaryColor, width: 1, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(5)),
      textStyle: TextStyle(
        fontSize: getProportionateScreenHeight(16),
        fontFamily: 'Raleway',
        fontWeight: FontWeight.bold,
      ));

  static ButtonStyle buttonStyleOutline = ElevatedButton.styleFrom(
    backgroundColor: backgroundColor,
    foregroundColor: secondaryColor,
    padding: EdgeInsets.symmetric(
      vertical: getProportionateScreenHeight(buttonPaddingV),
      // horizontal: getProportionateScreenWidth(buttonPaddingH)
    ),
    shape: RoundedRectangleBorder(
        side: BorderSide(
            color: secondaryColor, width: 1, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(5)),
    textStyle: TextStyle(
        fontSize: getProportionateScreenHeight(16),
        fontFamily: 'Raleway',
        fontWeight: FontWeight.bold),
  );

  static ButtonStyle buttonStyleIcon = TextButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: secondaryColor,
    elevation: 0,

    // shape: const RoundedRectangleBorder(
    //     side: BorderSide(color: Colors.transparent)),
    padding: EdgeInsets.symmetric(
        vertical: buttonPaddingV, horizontal: buttonPaddingH),
    textStyle: TextStyle(
        fontSize: getProportionateScreenHeight(16),
        fontFamily: 'Raleway',
        fontWeight: FontWeight.bold),
  );

  static TextStyle headingStyle = TextStyle(
    fontSize: getProportionateScreenHeight(18),
    fontWeight: FontWeight.bold,
    color: primaryColor,
    height: 1.5,
    letterSpacing: 1.0,
  );

  static TextStyle bodyStyle = TextStyle(
    fontSize: getProportionateScreenHeight(16),
    fontWeight: FontWeight.w100,
    color: primaryColor,
    height: 1.0,
    letterSpacing: 1.0,
  );

  static TextStyle bodySecondStyle = TextStyle(
    fontSize: getProportionateScreenHeight(16),
    fontWeight: FontWeight.w100,
    color: backgroundColor,
    height: 1.0,
    letterSpacing: 1.0,
  );

  ThemeData get materialTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'Raleway',
      appBarTheme: const AppBarTheme(
        color: Colors.transparent,
      ),
    );
  }
}
