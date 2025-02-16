import 'package:flutter/material.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AttendanceStatus extends StatefulWidget {
  const AttendanceStatus({
    Key? key,
  }) : super(key: key);

  @override
  State<AttendanceStatus> createState() => _AttendanceStatusState();
}

class _AttendanceStatusState extends State<AttendanceStatus> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Icon(
              Icons.bus_alert_rounded,
              size: 32.0,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        HorizontalSpacing(16.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.lastAttendance,
              style: Theme.of(context).textTheme.headlineMedium,
              textScaler: const TextScaler.linear(1.0),
            ),
            Text(
              "Hoy a las 12:00 P.M.",
              style: Theme.of(context).textTheme.labelLarge,
              textScaler: const TextScaler.linear(1.0),
            ),
          ],
        )
      ],
    );
  }
}
