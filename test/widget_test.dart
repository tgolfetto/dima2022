// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dima2022/main.dart';
import 'package:dima2022/models/user/auth.dart';
import 'package:dima2022/utils/providers.dart';
import 'package:dima2022/view/auth_screen.dart';
import 'package:dima2022/view/custom_theme.dart';
import 'package:dima2022/view/homepage_screen.dart';
import 'package:dima2022/view/on_boarding_screen.dart';
import 'package:dima2022/view_models/user_view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layout/layout.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Main test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    final nextButton = find.text('Next');
    expect(nextButton, findsOneWidget);
  });

  testWidgets('OnBoarding test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    final skipButton = find.byKey(const Key('skipButton'));
    expect(skipButton, findsOneWidget);
    await tester.tap(skipButton);
    await tester.pump();
    final signupButton = find.byKey(const Key('signupButton'));
    expect(signupButton, findsOneWidget);
  });

  testWidgets('SplashScreen test', (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: authProviders,
      child: Builder(
        builder: (_) => MaterialApp(
          title: CustomTheme.appTitle,
          theme: CustomTheme().materialTheme,
          debugShowCheckedModeBanner: false,
          home: const Layout(child: AuthScreen())),
      ),
    ),);
    await tester.pump(const Duration(milliseconds: 10000));
    expect(find.byKey(const Key('splashScreen')), findsOneWidget);
  });

  testWidgets('Auth test', (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: authProviders,
      child: Builder(
        builder: (_) => MaterialApp(
            title: CustomTheme.appTitle,
            theme: CustomTheme().materialTheme,
            debugShowCheckedModeBanner: false,
            home: Layout(
              child: Consumer<AuthViewModel>(
                builder: (context, auth, child) => Scaffold(
                  body: const AuthScreen().authScreenPage(context),
                  ),
                ),
              ),
            )),
      ),
    );
    await tester.pump();
    expect(find.byKey(const Key('loginButton')), findsOneWidget);

    await tester.enterText(find.byKey(const Key('emailField')),'thomas@thomas.it');
    await tester.enterText(find.byKey(const Key('passField')),'thomas');
    await tester.tap(find.byKey(const Key('signupInsteadButton')));
    await tester.pump();
    await tester.enterText(find.byKey(const Key('confirmPassField')),'thomas');
    await tester.tap(find.byKey(const Key('signupInsteadButton')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pump();
  });
}
