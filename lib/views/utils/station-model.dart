import 'package:flutter/cupertino.dart';
import 'package:simup_up/views/components/user_stations.dart';

class StationModel {
  static bool isLineOneWorking = false;
  static bool isLineTwoWorking = false;
  static int currentRouteOne = 0;
  static int currentRouteTwo = 0;
  static List<Map<String, dynamic>> routeOneStations = [];
  static List<Map<String, dynamic>> routeTwoStations = [];

  static List<int> routeOneRoundTripForward = [0, 1, 2, 3, 4, 5, 6, 7, 8];
  static List<int> routeOneRoundTripBackwards = [8, 7, 6, 5, 4, 3, 2, 1, 0];
  static List<int> routeTwoRoundTripBackwards = [8, 7, 6, 5, 4, 9, 10, 2];
  static List<int> routeTwoRoundTripForward = [2, 3, 4, 5, 6, 7, 8];

  static List<int> routeOneArrivalTimes = [0, 6, 2, 2, 5, 3, 3, 1, 3];
  static List<int> routeTwoArrivalTimes = [3, 3, 1, 3, 2, 2, 5, 3, 6];

  static void getStationIntervals(BuildContext context) {
    _getWorkingLines();
    _isItRoundTrip(context);
  }

  static void _getWorkingLines() {
    DateTime currentTime = DateTime.now();

    if (currentTime.hour >= 8 && currentTime.hour <= 19) {
      isLineOneWorking = true;
      isLineTwoWorking = true;
    } else {
      isLineOneWorking = false;
      isLineTwoWorking = false;
    }
  }

  static void _isItRoundTrip(BuildContext context) {
    DateTime currentTime = DateTime.now();
    int currentHour = currentTime.hour;
    int currentMinutes = currentTime.minute;

    if (currentHour == 5 && currentMinutes >= 30) {
      calculateStationIntervals(context, true);
    } else if (currentHour == 6 && currentMinutes >= 10) {
      calculateStationIntervals(context, false);
    } else if (currentHour == 7 && currentMinutes >= 0) {
      calculateStationIntervals(context, true);
    } else if (currentHour == 8 && currentMinutes >= 10) {
      calculateStationIntervals(context, false);
    } else if (currentHour == 9 && currentMinutes >= 00) {
      calculateStationIntervals(context, true);
    } else if (currentHour == 10 && currentMinutes >= 10) {
      calculateStationIntervals(context, false);
    } else if (currentHour == 11 && currentMinutes >= 0) {
      calculateStationIntervals(context, true);
    } else if (currentHour == 12 && currentMinutes >= 10) {
      calculateStationIntervals(context, false);
    } else if (currentHour == 13 && currentMinutes >= 0) {
      calculateStationIntervals(context, true);
    } else if (currentHour == 14 && currentMinutes >= 10) {
      calculateStationIntervals(context, false);
    } else if (currentHour == 15 && currentMinutes >= 0) {
      calculateStationIntervals(context, true);
    } else if (currentHour == 16 && currentMinutes >= 10) {
      calculateStationIntervals(context, false);
    } else if (currentHour == 17 && currentMinutes >= 0) {
      calculateStationIntervals(context, true);
    } else if (currentHour == 18 && currentMinutes >= 10) {
      calculateStationIntervals(context, false);
    }
  }

  static void _generateRouteSegments(BuildContext context, bool isItRouteOne, bool isItForward) {
    DateTime currentTime = DateTime.now();
    int currentHour = currentTime.hour;
    int currentMinute = 0;

    if (currentTime.hour == 5) {
      currentMinute = 30;
    } else if (!isItForward) {
      currentMinute = 10;
    }

    int currentStationIndex = 0; // Initialize current station index

    if (isItRouteOne) {
      List<int> roundTrip = isItForward ? routeOneRoundTripForward : routeOneRoundTripBackwards;

      for (int i = 0; i < roundTrip.length; i++) {
        routeOneStations.add(_generateStationInfo(context, roundTrip.elementAt(i), currentHour, currentMinute, routeOneArrivalTimes[i], true, roundTrip));

        // Update current station index
        if (isItForward) {
          currentStationIndex = i;
        } else {
          currentStationIndex = roundTrip.length - 1 - i;
        }

        currentMinute += routeOneArrivalTimes[i];
      }
    } else {
      List<int> roundTrip = isItForward ? routeTwoRoundTripForward : routeTwoRoundTripBackwards;

      for (int i = 0; i < roundTrip.length; i++) {
        routeTwoStations.add(_generateStationInfo(context, roundTrip.elementAt(i), currentHour, currentMinute, routeTwoArrivalTimes[i], false, roundTrip));

        // Update current station index
        if (isItForward) {
          currentStationIndex = i;
        } else {
          currentStationIndex = roundTrip.length - 1 - i;
        }

        currentMinute += routeTwoArrivalTimes[i];
      }
    }
  }

  static void _updateCurrentStationIndex(bool isItRouteOne, int currentIndex) {
    if (isItRouteOne) {
      currentRouteOne = currentIndex;
    } else {
      currentRouteTwo = currentIndex;
    }
  }

  static void calculateStationIntervals(BuildContext context, bool isItForward) {
    routeOneStations.clear();
    routeTwoStations.clear();

    // If forward. Check which lines are working and generate respectively.

    if (isItForward) {
      if (isLineOneWorking && isLineTwoWorking) {
        _generateRouteSegments(context, true, true);
        _generateRouteSegments(context, false, true);
      } else {
        _generateRouteSegments(context, true, true);
      }
    } else {
      if (isLineOneWorking && isLineTwoWorking) {
        _generateRouteSegments(context, true, false);
        _generateRouteSegments(context, false, false);
      } else {
        _generateRouteSegments(context, true, false);
      }
    }
  }

  static Map<String, dynamic> _generateStationInfo(BuildContext context, int index, int currentHour, int currentMinute, int interval, bool isItRouteOne, List<int> roundTrip) {
    return {
      "stationItem": UserStations.stationList.elementAt(index),
      "stationName": UserStations.stationNames(context).elementAt(index),
      "stationInfo": UserStations.stationInfo(context).elementAt(index),
      "stationAsset": UserStations.stationAsset.elementAt(index),
      "arrivalTime": _calculateArrivalTime(currentHour, currentMinute, interval, isItRouteOne, index)
    };
  }

  static String _calculateArrivalTime(int currentHour, int currentMinute, int interval, bool isItRouteOne, int currentIndex) {
    DateTime latestTime = DateTime.now();
    currentMinute += interval;
    currentHour += currentMinute ~/ 60;
    currentMinute %= 60;

    if (currentMinute <= latestTime.minute) {
      _updateCurrentStationIndex(isItRouteOne, currentIndex);
    }

    return "${currentHour.toString().padLeft(2, '0')}:${currentMinute.toString().padLeft(2, '0')}";
  }

  static List<Map<String, dynamic>> getStationsForDirection(bool isRouteOne) {
    return isRouteOne ? routeOneStations : routeTwoStations;
  }
}