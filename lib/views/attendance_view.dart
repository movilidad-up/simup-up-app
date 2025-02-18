import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/enums/enums.dart';
import 'package:simup_up/views/components/action_card.dart';
import 'package:simup_up/views/components/attendance_status.dart';
import 'package:simup_up/views/components/submit_attendance_button.dart';
import 'package:simup_up/views/history-view.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:simup_up/views/utils/custom-page-router.dart';

class AttendanceView extends StatefulWidget {
  const AttendanceView({super.key});

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {
  bool canCheckAttendance =
      true; // Prevent multiple submissions for the same trip

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
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
                  AttendanceStatus(status: SendStatus.sent),
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
                  SubmitAttendanceButton(),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
