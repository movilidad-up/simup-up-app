import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:simup_up/enums/enums.dart';
import 'package:simup_up/views/attendance_log_view.dart';
import 'package:simup_up/views/components/custom_toast.dart';
import 'package:simup_up/views/components/qr_status_radar.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/utils/attendance_service.dart';

class QrAttendanceView extends StatefulWidget {
  const QrAttendanceView({Key? key}) : super(key: key);

  @override
  State<QrAttendanceView> createState() => _QrAttendanceViewState();
}

class _QrAttendanceViewState extends State<QrAttendanceView> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              centerTitle: true,
              elevation: 4,
              shadowColor: Colors.grey[100]!,
              backgroundColor: Theme.of(context).colorScheme.surface,
              scrolledUnderElevation: 0.4,
              title: Text(
                AppLocalizations.of(context)!.attendance,
                style: Theme.of(context).textTheme.labelLarge,
                textScaler: const TextScaler.linear(1.0),
              ),
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  enableFeedback: false,
                  onPressed: () {
                    Navigator.of(context).pop();
                  }
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16.0, bottom: 16.0, left: 24.0, right: 24.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.qrAttendance,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          AppLocalizations.of(context)!.qrAttendanceInfo,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        VerticalSpacing(16.0),
                        QrStatusRadar(),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
