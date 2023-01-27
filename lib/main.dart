import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/providers.dart';
import 'utils/routes.dart';
import 'view/auth_screen.dart';
import 'view/widgets/common/custom_theme.dart';
import 'view/on_boarding_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _onboardingSeen = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingSeen();
  }

  void _checkOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _onboardingSeen = prefs.getBool('onboarding_seen') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: Providers.authProviders,
      child: MaterialApp(
        title: CustomTheme.appTitle,
        theme: CustomTheme().materialTheme,
        debugShowCheckedModeBanner: false,
        home: Layout(
            child: _onboardingSeen ? const AuthScreen() : const OnBoarding()),
        routes: Routes.routeList,
      ),
    );
  }
}
