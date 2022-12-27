import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

import '../models/exceptions/http_exception.dart';
import '../models/user/user.dart';

class UserService {
  // Function to create a new user in the database
  // @param user the user to be created
  // @require user != null
  // @ensure the user is created in the database
  Future<void> createUser(User user) async {
    final url = Uri.https(baseUrl, '/users.json', null);

    final http.Response response = await http.post(
      url,
      body: json.encode(user.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw HttpException('Failed to create user');
    }
  }

  // Function to update an existing user in the database
  // @param user the user to be updated
  // @require user != null
  // @ensure the user is updated in the database
  Future<void> updateUser(User user) async {
    final url = Uri.https(baseUrl, '/users/${user.id}.json', null);

    final http.Response response = await http.put(
      url,
      body: json.encode(user.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw HttpException('Failed to update user');
    }
  }

  // Function to delete a user from the database
  // @param userId the id of the user to be deleted
  // @require userId != null
  // @ensure the user is deleted from the database
  Future<void> deleteUser(String userId) async {
    final url = Uri.https(baseUrl, '/users/${userId}.json', null);
    final http.Response response = await http.delete(
      url,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw HttpException('Failed to delete user');
    }
  }

  // Function to get a single user from the database
  // @param userId the id of the user to be retrieved
  // @require userId != null
  // @ensure the user is retrieved from the database
  Future<User> getUser(String userId) async {
    final url = Uri.https(baseUrl, '/users/${userId}.json', null);
    final http.Response response = await http.get(
      url,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw HttpException('Failed to get user');
    }

    final Map<String, dynamic> userData = json.decode(response.body);
    return User.fromJson(userData);
  }
}
