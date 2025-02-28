import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:simup_up/views/beacon_attendance_view.dart';
import 'package:simup_up/views/components/primary_button.dart';
import 'package:simup_up/views/dashboard_view.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/utils/custom-page-router.dart';

class AttendanceLogView extends StatefulWidget {
  final String methodId;
  const AttendanceLogView({super.key, required this.methodId});

  @override
  _AttendanceLogViewState createState() => _AttendanceLogViewState();
}

class _AttendanceLogViewState extends State<AttendanceLogView> {
  String date = '';
  String time = '';
  String route = '';
  String attendanceStatus = '';
  String method = '';

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
  }

  Future<void> _loadAttendanceData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      date = prefs.getString('attendance_last_date') ?? 'N/A';
      time = prefs.getString('attendance_last_time') ?? 'N/A';
      route = prefs.getString('attendance_last_route') == 'route_1' ? "${AppLocalizations.of(context)!.route} 1" : "${AppLocalizations.of(context)!.route} 2" ?? 'N/A';
      attendanceStatus = prefs.getString('attendance_state') == 'sent' ? AppLocalizations.of(context)!.sent : AppLocalizations.of(context)!.onQueue ?? 'N/A';
      method = widget.methodId == 'beacon' ? AppLocalizations.of(context)!.beacon : AppLocalizations.of(context)!.qrCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
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
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Theme.of(context).colorScheme.surfaceContainer,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Icon(
                            Icons.check_rounded,
                            size: 32.0,
                            weight: 2.0,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      VerticalSpacing(24.0),
                      Text(
                        AppLocalizations.of(context)!.attendanceConfirmation,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        AppLocalizations.of(context)!.attendanceConfirmationInfo,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetail(context, AppLocalizations.of(context)!.date, date),
                      _buildDetail(context, AppLocalizations.of(context)!.hour, time),
                      _buildDetail(context, AppLocalizations.of(context)!.route, route),
                      _buildDetail(context, AppLocalizations.of(context)!.attendanceStatus, attendanceStatus),
                      _buildDetail(context, AppLocalizations.of(context)!.method, method),
                      VerticalSpacing(16.0),
                      PrimaryButton(
                          buttonText: AppLocalizations.of(context)!.goBack,
                          hasPadding: false,
                          onButtonPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(CustomPageRoute(ShowCaseWidget(
                              builder: (context) => const DashboardView(customIndex: 2),
                            )), (Route<dynamic> route) => false);
                          },
                          isButtonEnabled: true)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(BuildContext context, String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
          textScaler: const TextScaler.linear(1.0),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.labelLarge,
          textScaler: const TextScaler.linear(1.0),
        ),
        VerticalSpacing(8.0),
      ],
    );
  }
}