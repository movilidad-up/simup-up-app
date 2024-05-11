import 'package:flutter/cupertino.dart';
import 'package:simup_up/views/utils/route_status_checker.dart';
import 'package:simup_up/views/utils/route_stop_checker.dart';
import 'package:simup_up/views/utils/trip_route_generator.dart';

class StationModel {
  // Initializing variables.

  static int currentRouteOne = 0;
  static int currentRouteTwo = 0;
  static List<Map<String, dynamic>> routeOneStations = [];
  static List<Map<String, dynamic>> routeTwoStations = [];

  // First, we get the intervals for the whole route time.

  static void getStationIntervals(BuildContext context) {
    TripRouteGenerator.generateRouteBySchedule(context);
    routeOneStations = TripRouteGenerator.getRouteOne();
    routeTwoStations = TripRouteGenerator.getRouteTwo();
    currentRouteOne = TripRouteGenerator.getCurrentRouteOneIndex();
    currentRouteTwo = TripRouteGenerator.getCurrentRouteTwoIndex();
  }

  static int getCurrentStation(bool isItRouteOne) {
    if (isItRouteOne) {
      return currentRouteOne;
    } else {
      return currentRouteTwo;
    }
  }

  static List<Map<String, dynamic>> getStationsForDirection(bool isRouteOne) {
    return isRouteOne ? routeOneStations : routeTwoStations;
  }
}
