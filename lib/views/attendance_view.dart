import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simup_up/enums/enums.dart';
import 'package:simup_up/views/beacon_attendance_view.dart';
import 'package:simup_up/views/components/action_card.dart';
import 'package:simup_up/views/components/attendance_status.dart';
import 'package:simup_up/views/history-view.dart';
import 'package:simup_up/views/qr_attendance_view.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:simup_up/views/utils/attendance_service.dart';
import 'package:simup_up/views/utils/custom-page-router.dart';

class AttendanceView extends StatefulWidget {
  const AttendanceView({super.key});

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {
  bool canCheckAttendance = true;

  @override
  void initState() {
    super.initState();
    _loadAttendanceStatus();
  }

  Future<Map<String, dynamic>> getAttendanceStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String? lastDate = prefs.getString('last_attendance_date');
    String? lastTime = prefs.getString('attendance_last_time');
    int? lastTrip = prefs.getInt('last_attendance_trip');
    String? state = prefs.getString('attendance_state');

    return {
      'lastDate': lastDate,
      'lastTime': lastTime,
      'lastTrip': lastTrip,
      'state': state,
    };
  }

  Future<void> _loadAttendanceStatus() async {
    final prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();

    // Get trip number
    int tripNumber = AttendanceService().getTripNumber(now);

    // Create a unique key for today's attendance
    String todayKey = 'attendance_${now.year}_${now.month}_${now.day}_trip_$tripNumber';

    // Check if attendance was submitted today for this trip
    bool hasSubmitted = prefs.getBool(todayKey) ?? false;

    setState(() {
      canCheckAttendance = !hasSubmitted;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 32.0, bottom: 16.0, left: 24.0, right: 24.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.myAttendance,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      AppLocalizations.of(context)!.myAttendanceDescription,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.status,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textScaler: const TextScaler.linear(1.0),
                    ),
                    VerticalSpacing(8.0),
                    FutureBuilder<Map<String, dynamic>>(
                      future: getAttendanceStatus(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return CircularProgressIndicator();

                        String lastDate = snapshot.data!['lastDate'];
                        String lastTime = snapshot.data!['lastTime'];
                        String state = snapshot.data!['state'];

                        if (lastDate == null) {
                          return AttendanceStatus(status: SendStatus.awaiting);
                        } else if (state == 'queue') {
                          return AttendanceStatus(status: SendStatus.queue, lastDate: lastDate, lastTime: lastTime);
                        } else {
                          return AttendanceStatus(status: SendStatus.sent, lastDate: lastDate, lastTime: lastTime);
                        }
                      },
                    ),
                    VerticalSpacing(16.0),
                    Text(
                      AppLocalizations.of(context)!.manualSubmit,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textScaler: const TextScaler.linear(1.0),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      AppLocalizations.of(context)!.manualSubmitDescription,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    VerticalSpacing(16.0),
                    // SubmitAttendanceButton(),
                    ActionCard(
                      isEnabled: canCheckAttendance,
                      onSchedulesTap: () {
                        Navigator.of(context).push(CustomPageRoute(const BeaconAttendanceView())).then((_) {
                          setState(() {
                            _loadAttendanceStatus();
                          });
                        });
                      },
                      subtitle: AppLocalizations.of(context)!.beaconAttendance,
                      title: AppLocalizations.of(context)!.submitMyBeaconAttendance,
                      icon: Icons.send_rounded,
                    ),
                    VerticalSpacing(16.0),
                    ActionCard(
                      isEnabled: canCheckAttendance,
                      onSchedulesTap: () {
                        Navigator.of(context).push(CustomPageRoute(const QrAttendanceView())).then((_) {
                          setState(() {
                            _loadAttendanceStatus();
                          });
                        });
                      },
                      subtitle: AppLocalizations.of(context)!.qrAttendance,
                      title: AppLocalizations.of(context)!.submitMyQrAttendance,
                      icon: Icons.qr_code_scanner_rounded,
                    ),
                    VerticalSpacing(16.0),
                    Text(
                      AppLocalizations.of(context)!.manageAttendance,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textScaler: const TextScaler.linear(1.0),
                    ),
                    VerticalSpacing(16.0),
                    ActionCard(
                      onSchedulesTap: () {
                        Navigator.of(context).push(CustomPageRoute(const HistoryView()));
                      },
                      subtitle: AppLocalizations.of(context)!.history,
                      title: AppLocalizations.of(context)!.goToHistory,
                    ),
                    VerticalSpacing(8.0),
                    ActionCard(
                      onSchedulesTap: (){},
                      subtitle: AppLocalizations.of(context)!.signature,
                      title: AppLocalizations.of(context)!.goToSignature,
                    ),
                    VerticalSpacing(24.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
