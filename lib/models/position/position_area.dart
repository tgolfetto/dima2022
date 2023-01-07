import 'package:flutter/foundation.dart';

class PositionArea with ChangeNotifier {
  String? name;

  Map<String, double>? a;
  Map<String, double>? b;
  Map<String, double>? c;
  Map<String, double>? d;

  Map<String, List<String>>? userLogs;

  PositionArea({this.name, this.a, this.b, this.c, this.d, this.userLogs});

  factory PositionArea.fromJson(
    Map<String, dynamic> positionAreaData,
  ) {
    Map<String, List<String>> tempUserLogs = {};
    Map<String, dynamic> users = positionAreaData['users'];
    for (String user in users.keys) {
      List<dynamic>? userTimes = users[user];
      List<String> times = [];
      for (String time in userTimes!) {
        times.add(time);
      }
      tempUserLogs.addEntries([MapEntry(user, times)]);
    }

    var newp = PositionArea(
        name: positionAreaData['name'],
        a: {
          'latitude': positionAreaData['A']['latitude'],
          'longitude': positionAreaData['A']['longitude']
        },
        b: {
          'latitude': positionAreaData['B']['latitude'],
          'longitude': positionAreaData['B']['longitude']
        },
        c: {
          'latitude': positionAreaData['C']['latitude'],
          'longitude': positionAreaData['C']['longitude']
        },
        d: {
          'latitude': positionAreaData['D']['latitude'],
          'longitude': positionAreaData['D']['longitude']
        },
        userLogs: tempUserLogs);

    return newp;
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'A': a, 'B': b, 'C': c, 'D': d, 'users': userLogs};
  }

  void addTimeLog(String user, String time) {
    if(userLogs == null){
      return;
    }
    if (userLogs![user] != null) {
      userLogs![user]?.add(time);
    } else {
      userLogs!.addEntries([
        MapEntry(user, [time])
      ]);
    }
  }

  @override
  String toString() {
    return 'PositionArea{name: $name, A: $a, B: $b, C: $c, D: $d, users: $userLogs}';
  }
}
