import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  //this token expires afre some hours (ex. token of Firebase lasts 1 hour)
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
    String email,
    String password,
    String urlSegment,
  ) async {
    final _authority = "identitytoolkit.googleapis.com";
    final _path = "/v1/accounts:${urlSegment}";
    final _params = {
      "key": "AIzaSyCr1oFyRTRuplH34DYkpVRKF0_CHqEBTn8",
    };
    final url = Uri.https(_authority, _path, _params);

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['error'] != null) {
        //we have problem
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(
        seconds: int.parse(responseData['expiresIn']),
      ));
      _autoLogout(); // here it is when the use is logged in --> so, it is the point in which we can start the timer
      notifyListeners();
      // Setting up shared preferences
      final prefs = await SharedPreferences.getInstance();
      //json.encode <- encode a Map ... and then set the Map ... that now is converted as a long string as prefs
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expityDate': _expiryDate.toIso8601String()
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expityDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout(); //it is used to set again the Timer
    return true;
  }

  void logout() async {
    _userId = null;
    _token = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('userData');
    prefs.clear(); // in this way, we remove all the data
  }

  void _autoLogout() {
    if (_authTimer != null) {
      //so, we check if we do not have an existing timer
      _authTimer.cancel();
    }
    //we can set a TIMER (da dart.asych) that expires when the we reach the exipityDate
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
