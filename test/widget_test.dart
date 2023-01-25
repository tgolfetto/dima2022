import 'dart:convert';

import 'package:dima2022/main.dart';
import 'package:dima2022/models/user/auth.dart';
import 'package:dima2022/services/auth_service.dart';
import 'package:dima2022/utils/constants.dart';
import 'package:dima2022/utils/providers.dart';
import 'package:dima2022/view/auth_screen.dart';
import 'package:dima2022/view/custom_theme.dart';
import 'package:dima2022/view/splash_screen.dart';
import 'package:dima2022/view_models/user_view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layout/layout.dart';
import 'package:nock/nock.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



void main() {

  setUpAll(() {
    nock.init();
  });

  setUp(() {
    nock.cleanAll();
    final interceptor = nock("https://identitytoolkit.googleapis.com").post("/v1/accounts:signInWithPassword?key=AIzaSyCjphU9SWwimRUhpIjGGzQRlqfSd72H-Zc", json.encode(
      {
        'email': 'thomas@thomas.it',
        'password': 'thomas',
        'returnSecureToken': true,
      },
    ))
      ..reply(
        200,
        '{"kind":"identitytoolkit#VerifyPasswordResponse","localId":"xFt5SXvRdzQibaId5Wmuojf6oZO2","email":"thomas@thomas.it","displayName":"","idToken":"eyJhbGciOiJSUzI1NiIsImtpZCI6ImQwNWI0MDljNmYyMmM0MDNlMWY5MWY5ODY3YWM0OTJhOTA2MTk1NTgiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vZGltYTIwMjItNDkxYzQiLCJhdWQiOiJkaW1hMjAyMi00OTFjNCIsImF1dGhfdGltZSI6MTY3NDY3NTA1NywidXNlcl9pZCI6InhGdDVTWHZSZHpRaWJhSWQ1V211b2pmNm9aTzIiLCJzdWIiOiJ4RnQ1U1h2UmR6UWliYUlkNVdtdW9qZjZvWk8yIiwiaWF0IjoxNjc0Njc1MDU3LCJleHAiOjE2NzQ2Nzg2NTcsImVtYWlsIjoidGhvbWFzQHRob21hcy5pdCIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwiZmlyZWJhc2UiOnsiaWRlbnRpdGllcyI6eyJlbWFpbCI6WyJ0aG9tYXNAdGhvbWFzLml0Il19LCJzaWduX2luX3Byb3ZpZGVyIjoicGFzc3dvcmQifX0.QU4f4YUGGguJYXtFlRNkn5yIaB1FYn94l25uBBE5gMsTaCsVw9tX_8PArH8fc98_BSQ0eQWK_yzPq2yn8lEebNKAVwA0PsdQp_CQwD0MZ4ihcUS3sttcVtLGrMo6h0j6Je-qB9D8hxO19EnINmqlWsveJnAFHp8hZVkwgvj3LLtv7EqcKp5NNCQyQc6_Q5a2XX-vp3Jet23IdrpxxuMwiUmlUCr_7sJFhkHPSCl4VGJjq_WgtIgPUrfKEnt8yvhkyCnbROFdBsFaK-zALS6IqSC1OnzFa8DZL4aJoF-XqY3ZuXLs-8hqT774x6mhG7q4AQG8f0w_Q7na5HOizyHCtw","registered":true,"refreshToken":"APJWN8f-Ql1aF1UQsZmqEMDjmifcIApPt5TcOklkHETU8m_WrbqoooNV_oHpMwzdiYLCn0cyxGVpMfFYWuK5xIEQfzPEtkKm-Oqrz_qJyekVxMSxsBIUgS4e67eV-PMZZhKwPKof44VRVc9E5kgkJ8LIY4TDGZ-u5sp-nRBA5tzec-JCTUOLRiAE2LCS2cgclIuQX5mz_lIfk86ACzAQr0gc4SvZH7MqjQ","expiresIn":"3600"}',
      );
    SharedPreferences.setMockInitialValues({
      "key": "value"
    });
  });


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
    await tester.pumpWidget(
      MultiProvider(
        providers: authProviders,
        child: Builder(
          builder: (_) => MaterialApp(
              title: CustomTheme.appTitle,
              theme: CustomTheme().materialTheme,
              debugShowCheckedModeBanner: false,
              home: const Layout(child: SplashScreen())),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byKey(const Key('splashScreen')), findsOneWidget);
  });

  testWidgets('Auth test', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: authProviders,
        child: Builder(
            builder: (_) => MaterialApp(
                  title: CustomTheme.appTitle,
                  theme: CustomTheme().materialTheme,
                  debugShowCheckedModeBanner: false,
                  home: Layout(
                    child: Consumer<AuthViewModel>(
                      builder: (context, auth, child) => const Scaffold(
                        body: AuthScreen(),
                      ),
                    ),
                  ),
                )),
      ),
    );
    await tester.pump();
    expect(find.byKey(const Key('loginButton')), findsOneWidget);
    await tester.enterText(
        find.byKey(const Key('emailField')), 'thomas@thomas.it');
    await tester.enterText(find.byKey(const Key('passField')), 'thomas');
    await tester.tap(find.byKey(const Key('signupInsteadButton')));
    await tester.pump();
    await tester.enterText(find.byKey(const Key('confirmPassField')), 'thomas');
    await tester.tap(find.byKey(const Key('signupInsteadButton')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    expect(find.byKey(const ValueKey('HomePageBody')), findsOneWidget);
  });
}
