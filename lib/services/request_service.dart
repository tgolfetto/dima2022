import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/request/request.dart';
import '../utils/constants.dart';

class RequestService {
  // The user's authentication token
  static String? authToken;
  // The ID of the user
  static String? userId;

  // Update an existing request in the database
  // @param request: the request to be updated in the database
  // @require request != null
  // @ensure an existing request is updated in the database
  Future<void> updateRequest(Request request) async {
    final _params = {
      'auth': authToken,
    };
    final url = Uri.https(
        baseUrl, '/requests/${request.user.id}/${request.id}.json', _params);
    final response = await http.put(
      url,
      body: json.encode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update cart');
    }
  }
}
