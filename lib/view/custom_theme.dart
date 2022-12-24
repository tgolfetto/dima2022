import 'package:flutter/material.dart';

import '../model_view/size_config.dart';

class CustomTheme {
  static const String appTitle = 'DIMA App 2022';

  static ButtonStyle buttonStyle =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  static Color primaryColor = const Color(0xffea4b4b);
  static Color primaryLightColor = const Color(0xffebeded);
  static Color cardBackgroundColor = const Color(0xfff3f4f4);
  static LinearGradient primaryGradientColor = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
  );
  static Color secondaryColor = const Color(0xFF979797);
  static Color secondaryColorDark = const Color(0xff292929);

  static TextStyle headingStyle = TextStyle(
    fontSize: getProportionateScreenWidth(28),
    fontWeight: FontWeight.bold,
    color: secondaryColorDark,
    height: 1.5,
  );

  InputDecoration get otpInputDecoration {
    return InputDecoration(
      contentPadding:
          EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
      border: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      enabledBorder: outlineInputBorder,
    );
  }

  OutlineInputBorder get outlineInputBorder {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(getProportionateScreenWidth(2)),
      borderSide: BorderSide(color: secondaryColorDark),
    );
  }

  ThemeData get materialTheme {
    return ThemeData(
      primaryColor: Colors.blueGrey[900],
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Archivo',
      appBarTheme: const AppBarTheme(
        color: Colors.transparent,
      ),
      //scaffoldBackgroundColor: Colors.blue[300],
      primarySwatch: Colors.blue,
    );
  }
}
