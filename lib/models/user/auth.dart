import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  // token for the authenticated user
  String? _token;
  // expiration date of the token
  DateTime? _expiryDate;
  // id of the authenticated user
  String? _userId;
  // timer for automatic logout when the token expires
  Timer? _authTimer;

  // sets the token and notifies listeners
  void set token(String? token) {
    _token = token;
    notifyListeners();
  }

  // sets the userId and notifies listeners
  void set userId(String? userId) {
    _userId = userId;
    notifyListeners();
  }

  // sets the expiryDate and notifies listeners
  void set expiryDate(DateTime? expiryDate) {
    _expiryDate = expiryDate;
    notifyListeners();
  }

  // sets the authTimer and notifies listeners
  void set authTimer(Timer? authTimer) {
    _authTimer = authTimer;
    notifyListeners();
  }

  // returns true if the user is authenticated, false otherwise
  bool get isAuth {
    return token != null;
  }

  // returns the token if it exists and is not expired, null otherwise
  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  // returns the userId if it exists, null otherwise
  String? get userId {
    return _userId;
  }

  // returns the expiryDate if it exists, null otherwise
  DateTime? get expiryDate {
    return _expiryDate;
  }

  // returns the authTimer if it exists, null otherwise
  Timer? get authTimer {
    return _authTimer;
  }

  // sets the auth data and starts the automatic logout timer
  // @param token: token for the authenticated user
  // @param userId: id of the authenticated user
  // @param expiryDate: expiration date of the token
  void setAuthData(
    String token,
    String userId,
    DateTime expiryDate,
  ) {
    _token = token;
    _userId = userId;
    _expiryDate = expiryDate;
    autoLogout();
    notifyListeners();
  }

  // clears the auth data
  void _clearAuthData() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
  }

  // starts the automatic logout timer
  void autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
    notifyListeners();
  }

  Future<void> logout() async {
    _clearAuthData();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }
}
