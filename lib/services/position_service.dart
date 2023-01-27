import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/exceptions/http_exception.dart';

import '../models/position/position_area.dart';
import '../utils/constants.dart';
import 'protected_service.dart';

class PositionService extends ProtectedService {
  static const positionsPath = "/locations/man_area.json";

  PositionService(String authToken, String userId) : super(authToken, userId);

  Future<PositionArea> fetchAndSetPositionArea() async {
    const path = positionsPath;
    final Map<String, dynamic> params = {};
    params.addAll({
      'auth': authToken!,
    });

    final url = Uri.https(baseUrl, path, params);

    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final PositionArea loadedPositionArea =
          PositionArea.fromJson(extractedData);

      return loadedPositionArea;
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<PositionArea> updatePositionArea(PositionArea newPositionArea) async {
    const path = "/locations/man_area.json";
    final params = {
      'auth': authToken!,
    };

    final url = Uri.https(baseUrl, path, params);

    try {
      if (newPositionArea.name != null) {
        await http.patch(
          url,
          body: json.encode(newPositionArea.toJson()),
        );
      }
      return newPositionArea;
    } catch (error) {
      throw HttpException(error.toString());
    }
  }
}

/* MOCK JSON

{
  "A": {
    "latitude": 45.517544,
    "longitude": 9.098277
  },
  "B": {
    "latitude": 45.439906,
    "longitude": 9.250999
  },
  "C": {
    "latitude": 45.441099,
    "longitude": 9.122074
  },
  "D": {
    "latitude": 45.439906,
    "longitude": 9.238359
  },
  "name": "man_area",
  "users": {
    "xFt5SXvRdzQibaId5Wmuojf6oZO2": [
      "2023-01-04 20:18:04Z"
    ]
  }
}

 */
