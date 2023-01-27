import 'package:flutter/material.dart';

import '../view/auth_screen.dart';
import '../view/on_boarding_screen.dart';
import '../view/splash_screen.dart';

class Routes {
  static final Map<String, WidgetBuilder> routeList = {
    AuthScreen.routeName: (context) => const AuthScreen(),
    OnBoarding.routeName: (context) => const OnBoarding(),
    SplashScreen.routeName: (context) => const SplashScreen(),
  };
}
