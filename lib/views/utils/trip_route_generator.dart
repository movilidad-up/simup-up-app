import 'package:flutter/material.dart';
import 'package:simup_up/views/components/user_stations.dart';
import 'package:simup_up/views/utils/route_status_checker.dart';
import 'package:simup_up/views/utils/route_stop_checker.dart';
import 'package:simup_up/views/utils/route_trip_checker.dart';

class TripRouteGenerator {
  static bool isRouteOneOperational = false;
  static bool isRouteTwoOperational = false;
  static bool isRoundTrip = false;
  static int currentRouteOne = 0;
  static int currentRouteTwo = 0;
  static List<Map<String, dynamic>> routeOneStations = [];
  static List<Map<String, dynamic>> routeTwoStations = [];

  static List<int> routeOneRoundTripForward = [0, 1, 2, 3, 4, 5, 6, 7, 8];
  static List<int> routeOneRoundTripBackwards = [8, 7, 6, 5, 4, 3, 2, 1, 0];
  static List<int> routeTwoRoundTripBackwards = [8, 7, 6, 5, 4, 9, 10, 2];
  static List<int> routeTwoRoundTripForward = [2, 3, 4, 5, 6, 7, 8];

  static List<int> routeOneArrivalTimes = [0, 6, 2, 2, 5, 3, 3, 1, 3];
  static List<int> routeTwoArrivalTimesForward = [15, 2, 5, 3, 3, 1, 3];
  static List<int> routeTwoArrivalTimesBackwards = [10, 3, 1, 3, 3, 5, 6, 4];

  static int getCurrentRouteOneIndex() {
    return currentRouteOne;
  }

  static int getCurrentRouteTwoIndex() {
    return currentRouteTwo;
  }

  static void _getWorkingRoutes() {
    isRouteOneOperational = RouteStatusChecker.getRouteOneStatus();
    isRouteTwoOperational = RouteStatusChecker.getRouteTwoStatus();
  }

  // Remember, up to this point we already
  // checked if the routes are working and
  // made sure the bus in not on station.

  static void generateRouteBySchedule(BuildContext context) {
    _getWorkingRoutes();
    calculateStationIntervals(context);
  }

  // First, we check which lines to generate the route segments.

  // Depending on whether it is a round trip or not, we generate the intervals and store them on each list.

  static void calculateStationIntervals(BuildContext context) {
    bool isRouteOneOperational = RouteStatusChecker.getRouteOneStatus();
    bool isRouteTwoOperational = RouteStatusChecker.getRouteTwoStatus();
    routeOneStations.clear();
    routeTwoStations.clear();
    isRoundTrip = RoundTripChecker.isItForward();

    // If forward. Check which lines are working and generate respectively.

    if (isRouteOneOperational) {
      TripRouteGenerator.generateRouteSegments(context, true, isRoundTrip);
    }

    if (isRouteTwoOperational) {
      TripRouteGenerator.generateRouteSegments(context, false, isRoundTrip);
    }
  }

  // We add the calculated interval to each route.

  static void generateRouteSegments(BuildContext context, bool isItRouteOne, bool isItForward) {
    DateTime currentTime = DateTime.now();
    int currentHour = currentTime.hour;
    int currentMinute = 0;

    if (currentTime.hour == 5) {
      currentMinute = 30;
    } else if (!isItForward) {
      currentMinute = 10;
    }

    if (isItRouteOne) {
      List<int> roundTrip = isItForward ? routeOneRoundTripForward : routeOneRoundTripBackwards;

      for (int i = 0; i < roundTrip.length; i++) {
        routeOneStations.add(_generateStationInfo(context, roundTrip.elementAt(i), currentHour, currentMinute, routeOneArrivalTimes[i], true, roundTrip));
        currentMinute += routeOneArrivalTimes[i];
      }
    } else {
      List<int> roundTrip = isItForward ? routeTwoRoundTripForward : routeTwoRoundTripBackwards;
      List<int> arrivalTimes = isItForward ? routeTwoArrivalTimesForward : routeTwoArrivalTimesBackwards;

      for (int i = 0; i < roundTrip.length; i++) {
        routeTwoStations.add(_generateStationInfo(context, roundTrip.elementAt(i), currentHour, currentMinute, arrivalTimes[i], false, roundTrip));
        currentMinute += arrivalTimes[i];
      }
    }
  }

  // Up to this point, we fill both lists and render the route view.

  static Map<String, dynamic> _generateStationInfo(BuildContext context, int index, int currentHour, int currentMinute, int interval, bool isItRouteOne, List<int> roundTrip) {
    return {
      "stationItem": UserStations.stationList.elementAt(index),
      "stationName": UserStations.stationNames(context).elementAt(index),
      "stationInfo": UserStations.stationInfo(context).elementAt(index),
      "stationAsset": UserStations.stationAsset.elementAt(index),
      "stationIndex": index,
      "arrivalTime": _calculateArrivalTime(currentHour, currentMinute, interval, isItRouteOne, index)
    };
  }

  static String _calculateArrivalTime(int currentHour, int currentMinute, int interval, bool isItRouteOne, int currentIndex) {
    DateTime latestTime = DateTime.now();
    currentMinute += interval;
    currentHour += currentMinute ~/ 60;
    currentMinute %= 60;
    String arrivalTime = "";

    if (RouteStopChecker.isBusOnStop()) {
      arrivalTime = "Esperando salida";
    } else {
      if (currentMinute <= latestTime.minute) {
        _updateCurrentStationIndex(isItRouteOne, currentIndex);
      }
      arrivalTime = "${currentHour.toString().padLeft(2, '0')}:${currentMinute.toString().padLeft(2, '0')}";
    }

    return arrivalTime;
  }

  static void _updateCurrentStationIndex(bool isItRouteOne, int currentIndex) {
    if (isItRouteOne) {
      currentRouteOne = currentIndex;
    } else {
      currentRouteTwo = currentIndex;
    }
  }

  static List<Map<String, dynamic>> getRouteOne() {
    return routeOneStations;
  }

  static List<Map<String, dynamic>> getRouteTwo() {
    return routeTwoStations;
  }
}