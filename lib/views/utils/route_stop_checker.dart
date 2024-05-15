class RouteStopChecker {
  static bool isBusOnStop(bool isRouteOne) {
    DateTime currentTime = DateTime.now();
    int currentHour = currentTime.hour;
    int currentMinutes = currentTime.minute;
    bool isBusOnStop = false;

    bool isEvenHour = currentHour % 2 == 0;
    bool isStationTime = currentMinutes <= 10;
    bool isLateArrival = currentMinutes >= 50;

    if (isEvenHour && (isStationTime || isLateArrival)) {
      isBusOnStop = true;
    } else if (!isEvenHour && !isRouteOne && currentMinutes <= 15) {
      isBusOnStop = true;
    }

    return isBusOnStop;
  }
}