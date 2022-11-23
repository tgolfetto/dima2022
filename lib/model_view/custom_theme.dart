import 'package:flutter/material.dart';

const String appTitle = 'DIMA App 2022';

final ButtonStyle buttonStyle = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

class CustomTheme {
  final BorderRadius borderRadius = BorderRadius.circular(8);

  final Color colorYellow = const Color(0xffffff00);
  final Color colorPrimary = const Color(0xffabcdef);

  ThemeData get materialTheme {
    return ThemeData(
      primaryColor: Colors.lightBlue[800],
      fontFamily: 'Archivo',
    );
  }
}
