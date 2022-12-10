import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../view/cart_widget.dart';
import '../view/on_boarding.dart';
import '../view/homepage.dart';
import '../view/custom_theme.dart';

void main(){
  return runApp(ModularApp(module: AppModule(), child: const NavigationListener()));
}

class NavigationListener extends StatelessWidget {
  const NavigationListener({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: CustomTheme().materialTheme,
      themeMode: ThemeMode.light,
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
    );
  }
}

class AppModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
    ChildRoute('/', child: (context, args) => const OnBoarding()),
    ChildRoute('/homepage', child: (context, args) => const HomePage()),
    ChildRoute('/cart', child: (context, args) => const CartWidget()),
  ];
}