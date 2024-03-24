import 'package:flutter/cupertino.dart';
import 'package:simup_up/enums/enums.dart';
import 'package:simup_up/views/components/user_stations.dart';

class StationModel {
  static List<Map<String, dynamic>> routeOneStations = [];

  static void calculateStationIntervals(BuildContext context) {
    DateTime currentTime = DateTime.now();
    int currentHour = currentTime.hour;
    int currentMinute = (currentTime.minute >= 30) ? 30 : 00;

    routeOneStations = [
      {
        "stationItem": UserStations.stationList.elementAt(0),
        "stationName": UserStations.stationNames(context).elementAt(0),
        "stationInfo": UserStations.stationInfo(context).elementAt(0),
        "stationAsset": UserStations.stationAsset.elementAt(0),
        "arrivalTime": "${currentHour}:${currentMinute + 0 < 10 ? '0' : ''}${currentMinute += 0}"
      },
      {
        "stationItem": UserStations.stationList.elementAt(1),
        "stationName": UserStations.stationNames(context).elementAt(1),
        "stationInfo": UserStations.stationInfo(context).elementAt(1),
        "stationAsset": UserStations.stationAsset.elementAt(1),
        "arrivalTime": "${currentHour}:${currentMinute + 6 < 10 ? '0' : ''}${currentMinute += 6}"
      },
      {
        "stationItem": UserStations.stationList.elementAt(2),
        "stationName": UserStations.stationNames(context).elementAt(2),
        "stationInfo": UserStations.stationInfo(context).elementAt(2),
        "stationAsset": UserStations.stationAsset.elementAt(2),
        "arrivalTime": "${currentHour}:${currentMinute + 2 < 10 ? '0' : ''}${currentMinute += 2}"
      },
      {
        "stationItem": UserStations.stationList.elementAt(3),
        "stationName": UserStations.stationNames(context).elementAt(3),
        "stationInfo": UserStations.stationInfo(context).elementAt(3),
        "stationAsset": UserStations.stationAsset.elementAt(3),
        "arrivalTime": "${currentHour}:${currentMinute + 2 < 10 ? '0' : ''}${currentMinute += 2}"
      },
      {
        "stationItem": UserStations.stationList.elementAt(4),
        "stationName": UserStations.stationNames(context).elementAt(4),
        "stationInfo": UserStations.stationInfo(context).elementAt(4),
        "stationAsset": UserStations.stationAsset.elementAt(4),
        "arrivalTime": "${currentHour}:${currentMinute + 5 < 10 ? '0' : ''}${currentMinute += 5}"
      },
      {
        "stationItem": UserStations.stationList.elementAt(5),
        "stationName": UserStations.stationNames(context).elementAt(5),
        "stationInfo": UserStations.stationInfo(context).elementAt(5),
        "stationAsset": UserStations.stationAsset.elementAt(5),
        "arrivalTime": "${currentHour}:${currentMinute + 3 < 10 ? '0' : ''}${currentMinute += 3}"
      },
      {
        "stationItem": UserStations.stationList.elementAt(6),
        "stationName": UserStations.stationNames(context).elementAt(6),
        "stationInfo": UserStations.stationInfo(context).elementAt(6),
        "stationAsset": UserStations.stationAsset.elementAt(6),
        "arrivalTime": "${currentHour}:${currentMinute + 3 < 10 ? '0' : ''}${currentMinute += 3}"
      },
      {
        "stationItem": UserStations.stationList.elementAt(7),
        "stationName": UserStations.stationNames(context).elementAt(7),
        "stationInfo": UserStations.stationInfo(context).elementAt(7),
        "stationAsset": UserStations.stationAsset.elementAt(7),
        "arrivalTime": "${currentHour}:${currentMinute + 1 < 10 ? '0' : ''}${currentMinute += 1}"
      },
      {
        "stationItem": UserStations.stationList.elementAt(8),
        "stationName": UserStations.stationNames(context).elementAt(8),
        "stationInfo": UserStations.stationInfo(context).elementAt(8),
        "stationAsset": UserStations.stationAsset.elementAt(8),
        "arrivalTime": "$currentHour:${currentMinute + 3 < 10 ? '0' : ''}${currentMinute += 3}"
      },
    ];

    routeOneStations.forEach((station) {
      print("Arrives at ${station["stationName"]} at ${station["arrivalTime"]}");
    });
  }
}