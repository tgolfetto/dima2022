import 'package:dima2022/utils/routes.dart';
import 'package:dima2022/view/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';

import 'view/custom_theme.dart';
import 'view/on_boarding_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: CustomTheme.appTitle,
      theme: CustomTheme().materialTheme,
      debugShowCheckedModeBanner: false,
      home: const Layout(child: OnBoarding()), ///TODO: check if user already saw OnBoarding using shared_preferences
      routes: Routes.routeList,
    );
  }
}

