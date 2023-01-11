import 'dart:convert';

import 'package:dima2022/models/product/product_type.dart';
import 'package:http/http.dart' as http;
import '../models/product/category.dart';
import '../models/request/request.dart';

import '../utils/constants.dart';

import '../models/exceptions/http_exception.dart';

class RequestListService {
  // The user's authentication token
  String? _authToken;
  // The ID of the user
  String? _userId;

  // Constructor for RequestListService
  // @param authToken the user's authentication token
  // @param userId the ID of the user
  RequestListService(this._authToken, this._userId);

  // Fetch a list of requests of the logged user from the database
  // @return a list of Request objects
  // @throws HttpException if the request fails
  // @requires _authToken != null
  // @ensures returns a list of Request objects
  Future<List<Request>> fetchRequests() async {
    final _params = {
      'auth': _authToken,
    };
    final url = Uri.https(baseUrl, '/requests/$_userId.json', _params);
    final response = await http.get(url);
    try {
      final List<Request> loadedRequests = [];
      if (response.body == 'null') {
        return loadedRequests;
      }
      final extractedRequests =
          json.decode(response.body) as Map<String, dynamic>;

      final requests = extractedRequests.entries.map(
        (requestData) {
          return Request.fromJson(requestData);
        },
      ).toList();
      return requests;
    } catch (error) {
      throw HttpException('Failed to load requests');
    }
  }

  Future<List<Request>> fetchAllRequests() async {
    final _params = {
      'auth': _authToken,
    };
    final url = Uri.https(baseUrl, '/requests.json', _params);
    final response = await http.get(url);

    try {
      List<Request> requests = [];
      var uRequests;
      final requestsMap = json.decode(response.body) as Map<String, dynamic>;
      for (final ur in requestsMap.values) {
        var userRequests = ur as Map<String, dynamic>;
        uRequests = userRequests.entries.map(
          (requestData) {
            return Request.fromJson(requestData);
          },
        ).toList();
        requests.addAll(uRequests);
      }

      return requests;
    } catch (error) {
      throw HttpException('Failed to load requests');
    }
  }

  // Add a new request to the database
  // @param request: the request to be added to the database
  // @require request != null
  // @ensure a request is added to the database and its id is returned
  Future<Request> addRequest(Request request) async {
    final _params = {
      'auth': _authToken,
    };
    final url = Uri.https(baseUrl, '/requests/$_userId.json', _params);
    try {
      final response = await http.post(
        url,
        body: json.encode(request.toJson()),
      );
      request.id = json.decode(response.body)['name'];
      return request;
    } catch (error) {
      throw HttpException('Failed to add request');
    }
  }

  // Update an existing request in the database
  // @param request: the request to be updated in the database
  // @require request != null
  // @ensure an existing request is updated in the database
  Future<void> updateRequest(Request request) async {
    final _params = {
      'auth': _authToken,
    };
    final url = Uri.https(baseUrl, '/requests/$_userId.json', _params);
    final response = await http.put(
      url,
      body: json.encode(request.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update cart');
    }
  }

  // @param requestList: a list of requests to be updated in the database
  // @param _request: the request to be removed from the list
  // @require requestList != null, _request != null
  // @ensure the request is removed from the database and the updated list of requests is returned
  Future<List<Request>> removeRequest(
      List<Request> requestList, Request _request) async {
    final _path = "/requests/$_userId/${_request.id}.json";
    final _params = {
      'auth': _authToken!,
    };

    final url = Uri.https(baseUrl, _path, _params);

    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        requestList.add(_request);

        throw HttpException(
          'Could not delete product', //cosi andiamo a catchare in  user_product_screen
        );
      }
      return requestList;
    } catch (error) {
      throw HttpException(error.toString());
    }
  }
}
