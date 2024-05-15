import 'package:simup_up/views/utils/route_stop_checker.dart';

class RouteStatusChecker {
  static bool getRouteOneStatus() {
    DateTime currentTime = DateTime.now();
    int currentHour = _getCurrentHour(currentTime);

    if (_isRouteOneOperating(currentTime, currentHour)) {
      return true;
    } else {
      return false;
    }
  }

  static bool getRouteTwoStatus() {
    DateTime currentTime = DateTime.now();
    int currentHour = _getCurrentHour(currentTime);

    if (_isRouteTwoOperating(currentTime, currentHour)) {
      return true;
    } else {
      return false;
    }
  }

  static int _getCurrentHour(DateTime time) {
    return time.hour;
  }

  static bool _isRouteOneOperating(DateTime time, int hour) {
    /// Route 1 works in the range from monday to saturday.
    /// On weekdays it goes from 5:30 A.M. to 7:00 P.M.
    /// On saturday, it goes from 5:30 A.M. to 3:00 P.M.

    return ((time.weekday >= DateTime.monday && time.weekday <= DateTime.friday) ||
        (time.weekday == DateTime.saturday && hour < 15)) &&
        hour >= 5 && (hour > 5 || (hour == 5 && time.minute >= 30)) && // Start at 5:30 A.M.
        hour < 19;
  }

  static bool _isRouteTwoOperating(DateTime time, int hour) {
    /// Route 2 works in the range from monday to friday.
    /// On weekdays it goes from 8:10 A.M. to 7:00 P.M.

    return (time.weekday >= DateTime.monday &&
        time.weekday <= DateTime.friday &&
        hour >= 8 && // Start at 8:10 A.M.
        hour < 19);
  }

  static bool shouldGenerateRoute() {
    return (getRouteOneStatus() || getRouteTwoStatus()) && !RouteStopChecker.isBusOnStop(true);
  }
}