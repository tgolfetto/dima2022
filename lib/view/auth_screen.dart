import 'dart:io';

import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:provider/provider.dart';

import '../utils/size_config.dart';
import '../view_models/user_view_models/auth_view_model.dart';
import 'widgets/common/custom_theme.dart';
import 'homepage_screen.dart';
import 'splash_screen.dart';
import 'widgets/common/animated_circular_progress_indicator.dart';
import 'widgets/common/custom_button.dart';

enum AuthMode { signup, login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  Widget authScreenPage(BuildContext context) {
    SizeConfig().init(context);
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: SizedBox(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(
                      getProportionateScreenHeight(CustomTheme.smallPadding),
                    ),
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(
                      getProportionateScreenHeight(CustomTheme.smallPadding),
                    ),
                    child: Text(
                      'Gaetano Alessi - Thomas Golfetto',
                      style: CustomTheme.bodyStyle,
                    ),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                Flexible(
                  flex: deviceSize.width > 600 ? 3 : 2,
                  child: const AuthCard(),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Consumer<AuthViewModel>(
        builder: (context, auth, child) => Scaffold(
          body: auth.isAuthenticated
              ? const HomePage()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const SplashScreen()
                          : authScreenPage(context),
                ),
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  AuthCardState createState() => AuthCardState();
}

class AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;

  // a button to switch between sign-up and login
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.login) {
        // Log user in
        await Provider.of<AuthViewModel>(context, listen: false).login(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        // Sign user up
        await Provider.of<AuthViewModel>(context, listen: false).signup(
          _authData['email']!,
          _authData['password']!,
        );
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email is address is already in use';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could nt find an user with that email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid Password!';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      //errors that occurred because you lost internet connection
      const errorMessage = 'Could not authenticate you. Please try again later';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxWidth:
              deviceSize.width * 0.65 > 400 ? 400 : deviceSize.width * 0.65),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 2.0,
        shadowColor: Colors.transparent,
        child: Container(
          height: _authMode == AuthMode.signup ? 340 : 280,
          constraints: BoxConstraints(
              minHeight: _authMode == AuthMode.signup ? 340 : 290),
          width: deviceSize.width * 0.75,
          padding: EdgeInsets.all(
              getProportionateScreenHeight(CustomTheme.smallPadding)),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    key: const Key('emailField'),
                    decoration: const InputDecoration(
                      labelText: 'E-Mail',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['email'] = value!;
                    },
                  ),
                  TextFormField(
                    key: const Key('passField'),
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['password'] = value!;
                    },
                  ),
                  if (_authMode == AuthMode.signup)
                    TextFormField(
                      key: const Key('confirmPassField'),
                      enabled: _authMode == AuthMode.signup,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                      ),
                      obscureText: true,
                      validator: _authMode == AuthMode.signup
                          ? (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match!';
                              }
                              return null;
                            }
                          : null,
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  _isLoading
                      ? const AnimatedCircularProgressIndicator()
                      : CustomButton(
                          key: const Key("loginButton"),
                          outline: false,
                          transparent: false,
                          onPressed: _submit,
                          text:
                              _authMode == AuthMode.login ? 'LOGIN' : 'SIGN UP',
                        ),
                  TextButton(
                    key: const Key("signupInsteadButton"),
                    onPressed: _switchAuthMode,
                    child: Text(
                        '${_authMode == AuthMode.login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                        style: CustomTheme.bodyStyle),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
