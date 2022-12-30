import 'package:dima2022/view/on_boarding_screen.dart';
import 'package:dima2022/view/splash_screen.dart';
import 'package:dima2022/view/widgets/homepage_widgets/barcode_scanner.dart';
import 'package:flutter/material.dart';
import '../view/auth_screen.dart';
import '../view/widgets/homepage_widgets/plp.dart';

class Routes{
  static Map<String, Widget Function(BuildContext)> routeList = {
    AuthScreen.routeName: (context) => const AuthScreen(),
    OnBoarding.routeName: (context) => const OnBoarding(),
    SplashScreen.routeName: (context) => const SplashScreen(),
  };

}