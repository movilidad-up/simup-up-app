import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:simup_up/enums/enums.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/attendance_log_view.dart';
import 'package:simup_up/views/attendance_view.dart';
import 'package:simup_up/views/components/primary_button.dart';
import 'package:simup_up/views/dashboard_view.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:simup_up/views/utils/attendance_service.dart';
import 'package:simup_up/views/utils/beacon_checker.dart';
import 'package:simup_up/views/utils/custom-page-router.dart';
import 'package:simup_up/views/utils/status_radar_utils.dart';
import 'custom_toast.dart';

class StatusRadar extends StatefulWidget {
  final RadarStatus currentStatus;
  const StatusRadar({Key? key, this.currentStatus = RadarStatus.ready}) : super(key: key);

  @override
  State<StatusRadar> createState() => _StatusRadarState();
}

class _StatusRadarState extends State<StatusRadar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  RadarStatus currentStatus = RadarStatus.ready;
  int detectedRoute = 1;
  int _countdown = 5;

  int getTripNumber(DateTime currentTime) {
    // Define trip schedules (Monday - Friday & Saturday)
    final List<String> weekdayTrips = [
      "06:00", "08:00", "10:00", "12:00", "14:00", "16:00", "18:00"
    ];
    final List<String> saturdayTrips = [
      "06:00", "08:00", "10:00", "12:00", "14:00", "16:00"
    ];

    // Select the correct schedule based on the day
    List<String> tripSchedule = currentTime.weekday == DateTime.saturday
        ? saturdayTrips
        : weekdayTrips;

    // Iterate through the trips to determine the current trip number
    for (int i = 0; i < tripSchedule.length; i++) {
      DateTime tripTime = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        int.parse(tripSchedule[i].split(":")[0]),
        int.parse(tripSchedule[i].split(":")[1]),
      );

      if (currentTime.isBefore(tripTime)) {
        return i + 1; // Trip numbers are 1-based
      }
    }

    // If it's past the last trip time, return the last trip number
    return tripSchedule.length;
  }

  void main() {
    DateTime now = DateTime.now();
    int tripNumber = getTripNumber(now);
    print("Current trip number: $tripNumber");
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> checkInternetConnection() async {
    return await InternetConnection().hasInternetAccess;
  }

  Future<RadarStatus> sendAttendance() async {
    try {
      await AttendanceService().registerAttendanceFromSignature(detectedRoute, "bluetooth_beacon");
      return RadarStatus.success;
    } catch (e) {
      print("❌ Error sending attendance: $e");
      return RadarStatus.tooFar;
    }
  }

  Future<void> queueAttendanceForLater() async {
    try {
      await AttendanceService().queueAttendanceForLater(detectedRoute, "bluetooth_beacon");
      print("📌 Attendance stored for later.");
    } catch (e) {
      print("❌ Error queuing attendance: $e");
    }
  }

  Future<void> _startCountdown() async {
    while (_countdown > 0) {
      setState(() {}); // Update UI
      await Future.delayed(const Duration(seconds: 1));
      _countdown--;
    }

    // Redirect to AttendanceLogView after countdown
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AttendanceLogView(methodId: 'beacon')),
    );
  }

  Future<void> _handleAttendanceSubmission() async {
    setState(() {
      currentStatus = RadarStatus.scanning;
      _controller.repeat(reverse: true);
    });

    currentStatus = await BeaconChecker.checkBeaconStatus();
    detectedRoute = BeaconChecker.detectedRouteNumber!;

    if (currentStatus == RadarStatus.sending) {
      setState(() {
        currentStatus = RadarStatus.sending;
      });

      bool hasInternet = await checkInternetConnection();

      if (hasInternet) {
        currentStatus = await sendAttendance();
      } else {
        await queueAttendanceForLater();
        setState(() {
          currentStatus = RadarStatus.successQueue;
        });
      }
    }

    setState(() {
      if (currentStatus == RadarStatus.success) {
        CustomToast.buildToast(
          context,
          const Color(0xFF44B300),
          AppLocalizations.of(context)!.beaconAttendanceSent,
          AppLocalizations.of(context)!.beaconAttendanceSentInfo,
          Icons.check_circle,
        );
        _startCountdown();
      } else if (currentStatus == RadarStatus.successQueue) {
        CustomToast.buildToast(
          context,
          const Color(0xFFFFA500),
          "Attendance Queued",
          "Your attendance will be sent when online.",
          Icons.schedule,
        );
        _startCountdown();
      } else {
        CustomToast.buildToast(
          context,
          const Color(0xFFE40000),
          AppLocalizations.of(context)!.beaconAttendanceFailed,
          AppLocalizations.of(context)!.beaconAttendanceFailedInfo,
          Icons.error_rounded,
        );
      }
      _controller.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    bool isProcessing = currentStatus == RadarStatus.scanning || currentStatus == RadarStatus.sending;
    bool isSuccess = currentStatus == RadarStatus.success || currentStatus == RadarStatus.successQueue;

    String successStatusText() {
      if (currentStatus == RadarStatus.success || currentStatus == RadarStatus.successQueue) {
        return ". ${AppLocalizations.of(context)!.redirectIn} $_countdown ${AppLocalizations.of(context)!.seconds}.";
      } else {
        return "";
      }
    }

    return InkWell(
      onTap: (!isProcessing && !isSuccess) ? _handleAttendanceSubmission : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _opacityAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: isProcessing ? _opacityAnimation.value : 0.4,
                      child: Container(
                        width: 120.0,
                        height: 120.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: StatusRadarUtils.statusColors[currentStatus]!.withOpacity(0.2),
                        ),
                      ),
                    );
                  },
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: StatusRadarUtils.statusColors[currentStatus],
                    borderRadius: BorderRadius.circular(64.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(
                      StatusRadarUtils.statusIcons[currentStatus],
                      color: Colors.white,
                      size: 32.0,
                    ),
                  ),
                ),
              ],
            ),
            VerticalSpacing(16.0),
            SizedBox(
              width: screenWidth - 48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    StatusRadarUtils.getStatusText(context, currentStatus),
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  VerticalSpacing(4.0),
                  Text(
                    StatusRadarUtils.getStatusInfoText(context, currentStatus) + successStatusText(),
                    style: Theme.of(context).textTheme.labelLarge,
                    textAlign: TextAlign.center,
                  ),
                  if (isSuccess) ...[
                    VerticalSpacing(16.0),
                    PrimaryButton(
                      onButtonPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const AttendanceLogView(methodId: 'beacon')),
                        );
                      },
                      isButtonEnabled: true,
                      hasPadding: false,
                      buttonText: AppLocalizations.of(context)!.showTicket
                    ),
                    VerticalSpacing(8.0),
                    PrimaryButton(
                      primaryStyle: false,
                      onButtonPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(CustomPageRoute(ShowCaseWidget(
                          builder: (context) => const DashboardView(customIndex: 2),
                        )), (Route<dynamic> route) => false);
                      },
                      isButtonEnabled: true,
                      hasPadding: false,
                      buttonText: AppLocalizations.of(context)!.goBack
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
