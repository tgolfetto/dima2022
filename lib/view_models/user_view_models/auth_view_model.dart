import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/auth_service.dart';

import '../../models/user/auth.dart';
import '../../services/user_service.dart';

class AuthViewModel extends ChangeNotifier {
  // The authentication service used to sign up and log in users
  late final AuthService _authService;
  late final UserService _userService;
  // The current authentication state of the user
  late Auth _auth;

  /*
  Initializes the authentication view model and sets the authentication service
  to use and the initial state of the user's authentication
  */
  AuthViewModel() {
    _auth = Auth();
    _authService = AuthService();
  }
  /*
  The token for the authenticated user
  @ensure The token for the authenticated user will be returned
  */
  get token => _auth.token;
  /*
  The id of the authenticated user
  @ensure The id of the authenticated user will be returned
  */
  get userId => _auth.userId;
  /*
  Whether the user is currently authenticated
  @ensure The authentication status of the user will be returned
  */
  get isAuthenticated => _auth.isAuth;

  /*
  Signs up a user with the given email and password
  @require The email argument must not be null and must be a valid email address
  @require The password argument must not be null
  @ensure The user will be signed up and the authentication state will be updated
  */
  Future<void> signup(String email, String password) async {
    _auth = await _authService.signup(email, password);
    _userService = UserService(_auth.token, _auth.userId);
    await _userService.createUser(email);
    notifyListeners();
  }

  /*
  Logs in a user with the given email and password
  @require The email argument must not be null and must be a valid email address
  @require The password argument must not be null 
  @ensure The user will be logged in and the authentication state will be updated
  */
  Future<void> login(String email, String password) async {
    _auth = await _authService.login(email, password);
    notifyListeners();
  }

  /*
  Attempts to log in the user automatically if their authentication data is stored in shared preferences
  @ensure The user will be logged in and the authentication state will be updated if their data is stored
  in shared preferences and the data is not expired, otherwise the user will not be logged in and the
  authentication state will not be updated
  */
  Future<bool> tryAutoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expityDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _auth.token = extractedUserData['token'];
    _auth.userId = extractedUserData['userId'];
    _auth.expiryDate = expiryDate;
    notifyListeners();
    _auth.autoLogout(); //it is used to set again the Timer
    return true;
  }

  /*
  Logs out the current user
  @ensure The user will be logged out and the authentication state will be updated
  */
  Future<void> logout() async {
    await _auth.logout();
    notifyListeners();
  }
}
