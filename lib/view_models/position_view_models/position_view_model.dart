import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../models/position/position_area.dart';
import '../../services/position_service.dart';
import '../user_view_models/auth_view_model.dart';

class PositionViewModel extends ChangeNotifier {
  late final PositionService _positionService;

  late PositionArea _positionArea;

  late LocationSettings locationSettings;

  DateTime _lastLog = DateTime.now();

  PositionViewModel() {
    _positionArea = PositionArea();
  }

  PositionViewModel.fromAuth(
      String? token, String? userId, PositionViewModel? previousPosition) {
    _positionService = PositionService(token!, userId!);
    _positionArea = previousPosition == null
        ? _positionArea = PositionArea()
        : previousPosition._positionArea;
  }

  PositionArea get position => _positionArea;

  Future<void> updatePositionArea(PositionArea newPositionArea) async {
    _positionArea = await _positionService.updatePositionArea(newPositionArea);
    notifyListeners();
  }

  Future<void> fetchAndSetPositionArea() async {
    if (_positionArea.name == null) {
      _positionArea = await _positionService.fetchAndSetPositionArea();
      notifyListeners();
    }
  }

  Future<void> listenLocation(BuildContext ctx) async {
    await Geolocator.requestPermission();

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
                "Example app will continue to receive your location even when you aren't using it",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      DateTime currentTime = DateTime.now();
      if (currentTime.difference(_lastLog).inSeconds > 10) {
        _lastLog = currentTime;
        if (_positionArea.name == null) {
          fetchAndSetPositionArea();
        } else {
          if (position != null &&
              pointInRectangle(position.latitude, position.longitude)) {
            if (kDebugMode) {
              print(
                  '### LOCATION INSIDE AREA ${_positionArea.name}: ${position.latitude.toString()}, ${position.longitude.toString()}');
            }
            String userId =
                Provider.of<AuthViewModel>(ctx, listen: false).userId;
            _positionArea.addTimeLog(userId, currentTime.toIso8601String());
            updatePositionArea(_positionArea);
          }
        }
      }
    });
  }

  bool pointInRectangle(myLatitude, myLongitude) {
    Map AB = vector(_positionArea.a, _positionArea.b);
    Map AM = vector(
        _positionArea.a, {'latitude': myLatitude, 'longitude': myLongitude});
    Map BC = vector(_positionArea.b, _positionArea.c);
    Map BM = vector(
        _positionArea.b, {'latitude': myLatitude, 'longitude': myLongitude});
    double dotABAM = dot(AB, AM);
    double dotABAB = dot(AB, AB);
    double dotBCBM = dot(BC, BM);
    double dotBCBC = dot(BC, BC);
    return 0 <= dotABAM &&
        dotABAM <= dotABAB &&
        0 <= dotBCBM &&
        dotBCBM <= dotBCBC;
  }

  Map vector(Map<String, double>? p1, Map<String, double>? p2) {
    return {
      'latitude': (p2!['latitude']! - p1!['latitude']!),
      'longitude': (p2['longitude']! - p1['longitude']!)
    };
  }

  double dot(Map u, Map v) {
    return u['latitude']! * v['latitude']! + u['longitude']! * v['longitude']!;
  }
}
