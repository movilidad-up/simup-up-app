import 'package:flutter/material.dart';
import 'package:simup_up/enums/enums.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AttendanceStatus extends StatefulWidget {
  final SendStatus status;
  final String lastDate;
  final String lastTime;

  const AttendanceStatus({
    Key? key, required this.status, this.lastDate = "", this.lastTime = ""
  }) : super(key: key);

  @override
  State<AttendanceStatus> createState() => _AttendanceStatusState();
}

class _AttendanceStatusState extends State<AttendanceStatus> {
  String _buildStatusDate() {
    String date = "";

    if (widget.lastDate.isNotEmpty && widget.lastTime.isNotEmpty) {
      date = "${widget.lastDate} at ${widget.lastTime}";
      return date;
    } else {
      return "First time";
    }
  }

  Map<String, dynamic> _buildStatusMap() {
    SendStatus status = widget.status;
    Map<String, dynamic> statusMap = {
      'statusTitle': "",
      'statusInfo': "",
      'icon': ""
    };

    switch (status) {
      case SendStatus.sent:
        statusMap['statusTitle'] = AppLocalizations.of(context)!.lastAttendance;
        statusMap['statusInfo'] = _buildStatusDate();
        statusMap['statusIcon'] = Icons.directions_bus_filled_rounded;
        break;
      case SendStatus.queue:
        statusMap['statusTitle'] = AppLocalizations.of(context)!.awaitingConnection;
        statusMap['statusInfo'] = AppLocalizations.of(context)!.awaitingConnectionDescription;
        statusMap['statusIcon'] = Icons.schedule_send_rounded;
        break;
      case SendStatus.awaiting:
        statusMap['statusTitle'] = AppLocalizations.of(context)!.awaitingConnection;
        statusMap['statusInfo'] = AppLocalizations.of(context)!.awaitingConnectionDescription;
        statusMap['statusIcon'] = Icons.send_rounded;
        break;
    }

    return statusMap;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> statusMap = _buildStatusMap();

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
              statusMap['statusIcon'],
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
              statusMap['statusTitle'],
              style: Theme.of(context).textTheme.headlineMedium,
              textScaler: const TextScaler.linear(1.0),
            ),
            Text(
              statusMap['statusInfo'],
              style: Theme.of(context).textTheme.labelLarge,
              textScaler: const TextScaler.linear(1.0),
            ),
          ],
        ),
      ],
    );
  }
}
