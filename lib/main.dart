import 'package:dima2022/view/homepage.dart';
import 'package:dima2022/view/pdp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:layout/layout.dart';
import 'view/cart_widget.dart';
import 'view/on_boarding.dart';
import 'view/homepage.dart';
import 'view/custom_theme.dart';

void main() {
  return runApp(
      ModularApp(module: AppModule(), child: const NavigationListener()));
}

class NavigationListener extends StatelessWidget {
  const NavigationListener({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: appTitle,
        theme: CustomTheme().materialTheme,
        themeMode: ThemeMode.light,
        routeInformationParser: Modular.routeInformationParser,
        routerDelegate: Modular.routerDelegate,
      ),
    );
  }
}

class AppModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => const OnBoarding()),
        //ChildRoute('/homepage', child: (context, args) => const HomePage()),
        ChildRoute(
          '/homepage',
          child: (context, args) => MyHomePage(title: 'Home'),
        ),
        ChildRoute('/cart', child: (context, args) => const CartWidget()),
        ChildRoute('/pdp', child: (context, args) => Pdp(model: args.data))
      ];
}