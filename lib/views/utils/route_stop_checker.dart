class RouteStopChecker {
  static bool isBusOnStop() {
    DateTime currentTime = DateTime.now();
    int currentHour = currentTime.hour;
    int currentMinutes = currentTime.minute;
    bool isBusOnStop = false;

    if (currentHour % 2 == 0) {
      if (currentMinutes <= 10) {
        isBusOnStop = true;
      } else if (currentMinutes >= 50) {
        isBusOnStop = true;
      }
    }

    return isBusOnStop;
  }
}