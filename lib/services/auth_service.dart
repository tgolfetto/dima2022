import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

import '../models/user/auth.dart';
import '../models/exceptions/http_exception.dart';

class AuthService {
  // Default constructor for AuthService
  AuthService();

  // Sends an HTTP request to the Google Identity Toolkit API to authenticate the user
  // @param email the email of the user
  // @param pwd the password of the user
  // @param urlSegment the URL segment for the specific authentication request (either "signUp" or "signInWithPassword")
  // @require email, pwd, and urlSegment are not null
  // @ensure returns an Auth object with the authentication data if the request is successful, or throws an error if the request fails
  Future<Auth> _authenticate(
      String email, String pwd, String urlSegment) async {
    final _path = "/v1/accounts:${urlSegment}";
    final _params = {
      "key": ApiKey,
    };
    final url = Uri.https(baseAuthUrl, _path, _params);

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': pwd,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        //we have problem
        throw HttpException(responseData['error']['message']);
      }

      final token = responseData['idToken'];
      final userId = responseData['localId'];
      final expiryDate = DateTime.now().add(Duration(
        seconds: int.parse(responseData['expiresIn']),
      ));

      // Setting up shared preferences
      final prefs = await SharedPreferences.getInstance();
      //json.encode <- encode a Map ... and then set the Map ... that now is converted as a long string as prefs
      final userData = json.encode(
        {
          'token': token,
          'userId': userId,
          'expityDate': expiryDate.toIso8601String()
        },
      );
      prefs.setString('userData', userData);

      return Auth()..setAuthData(token, userId, expiryDate);
    } catch (error) {
      throw error;
    }
  }

  // Sends a signup request to the Google Identity Toolkit API
  // @param email the email of the user
  // @param password the password of the user
  // @require email and password are not null
  // @ensure returns an Auth object with the authentication data if the request is successful, or throws an error if the request fails
  Future<Auth> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  // Sends a login request to the Google Identity Toolkit API
  // @param email the email of the user
  // @param password the password of the user
  // @require email and password are not null
  // @ensure returns an Auth object with the authentication data if the request is successful, or throws an error if the request fails
  Future<Auth> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
