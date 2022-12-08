import 'package:flutter/material.dart';

const String appTitle = 'DIMA App 2022';

final ButtonStyle buttonStyle = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

class CustomTheme {
  ThemeData get materialTheme {
    return ThemeData(
      primaryColor: Colors.blueGrey[900],
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Archivo',
    );
  }
}
