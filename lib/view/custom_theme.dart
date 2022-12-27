import 'package:flutter/material.dart';
import '../utils/size_config.dart';

class CustomTheme {
  static const String appTitle = 'DIMA App 2022';

  static double spacePadding = 8.0;
  static double smallPadding = 12.0;
  static double mediumPadding = 24.0;
  static double bigPadding = 32.0;

  static ButtonStyle buttonStyleFill = ElevatedButton.styleFrom(
      backgroundColor: secondaryColor,
      foregroundColor: backgroundColor,
      padding: EdgeInsets.all(smallPadding),
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: secondaryColor, width: 1, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(5)),
      textStyle: const TextStyle(
        fontSize: 16,
        fontFamily: 'Raleway',
        fontWeight: FontWeight.bold,
      ));

  static ButtonStyle buttonStyleOutline = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: secondaryColor,
      padding: EdgeInsets.all(smallPadding),
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: secondaryColor, width: 1, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(5)),
      textStyle: const TextStyle(
          fontSize: 16, fontFamily: 'Raleway', fontWeight: FontWeight.bold));

  static Color primaryColor = Colors.black;
  static Color backgroundColor = Colors.white;
  static Color secondaryColor = Colors.teal;
  static Color accentColor = Colors.redAccent;
  static Color secondaryBackgroundColor = Colors.grey;

  static TextStyle headingStyle = TextStyle(
    fontSize: getProportionateScreenWidth(28),
    fontWeight: FontWeight.bold,
    color: primaryColor,
    height: 1.5,
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
