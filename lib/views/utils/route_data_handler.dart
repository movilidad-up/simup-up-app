import 'package:flutter/material.dart';
import 'package:simup_up/views/components/user_stations.dart';
import 'package:simup_up/views/utils/route_stop_checker.dart';
import 'package:simup_up/views/utils/station-model.dart';

class RouteDataHandler {
  static bool _checkIfOnStop(bool isRouteOne) {
    return RouteStopChecker.isBusOnStop(isRouteOne);
  }

  static String getCurrentStationName(bool isRouteOne, BuildContext context) {
    final stations = StationModel.getStationsForDirection(isRouteOne);
    final int currentStation = isRouteOne ? StationModel.currentRouteOne : StationModel.currentRouteTwo;
    final matchingStations = stations.where((station) => station['stationIndex'] == currentStation).toList();
    String stationName = "";

    // If on stop, we just simply show the respective start/end station.

    if (_checkIfOnStop(isRouteOne)) {
      DateTime currentTime = DateTime.now();
      int currentHour = currentTime.hour;
      int currentMinutes = currentTime.minute;
      bool isItForwardStation = true;

      // Check if it is El Palustre or Villa.

      if (currentHour % 2 == 0) {
        if (currentMinutes <= 10) {
          isItForwardStation = false;
        } else if (currentMinutes >= 50) {
          isItForwardStation = true;
        }
      }

      if (isItForwardStation) {
        stationName = isRouteOne ? UserStations.stationNames(context)[0] : UserStations.stationNames(context)[2];
      } else {
        stationName = UserStations.stationNames(context)[8];
      }

      return stationName;
    }

    // If on route, return calculated station.

    if (matchingStations.isNotEmpty) {
      return matchingStations.first["stationName"];
    } else {
      return "";
    }
  }
}
