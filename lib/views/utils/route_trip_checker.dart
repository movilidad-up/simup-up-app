class RoundTripChecker {
    static bool isItForward() {
    DateTime currentTime = DateTime.now();
    int currentHour = currentTime.hour;
    bool isItForward = true;

    if (currentHour % 2 == 0) {
      isItForward = false;
    }

    return isItForward;
  }
}