import 'package:flutter/material.dart';
import 'package:simup_up/enums/enums.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/utils/beacon_checker.dart';
import 'custom_toast.dart';

class SubmitAttendanceButton extends StatefulWidget {
  const SubmitAttendanceButton({Key? key}) : super(key: key);

  @override
  State<SubmitAttendanceButton> createState() => _SubmitAttendanceButtonState();
}

class _SubmitAttendanceButtonState extends State<SubmitAttendanceButton> {
  bool isLoading = false;
  SendStatus status = SendStatus.awaiting;

  Future<void> _handleAttendanceSubmission() async {
    setState(() {
      isLoading = true;
    });

    bool isNearValidBeacon = await BeaconChecker.isNearValidBeacon();

    if (isNearValidBeacon) {
      CustomToast.buildToast(
          context,
          const Color(0xFF44B300),
          AppLocalizations.of(context)!.beaconAttendanceSent,
          AppLocalizations.of(context)!.beaconAttendanceSentInfo,
          Icons.error_rounded);
      setState(() {
        status = SendStatus.sent;
      });
    } else {
      CustomToast.buildToast(
          context,
          const Color(0xFFE40000),
          AppLocalizations.of(context)!.beaconAttendanceFailed,
          AppLocalizations.of(context)!.beaconAttendanceFailedInfo,
          Icons.error_rounded);
      // Fluttertoast.showToast(msg: "No estás cerca de un beacon autorizado.");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(24.0),
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(24.0),
        onTap: status == SendStatus.awaiting ? _handleAttendanceSubmission : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.attendance,
                    style: Theme.of(context).textTheme.labelLarge,
                    textScaler: const TextScaler.linear(1.0),
                  ),
                  Text(
                    AppLocalizations.of(context)!.submitMyAttendance,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textScaler: const TextScaler.linear(1.0),
                  ),
                ],
              ),
              isLoading
                  ? SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
                  : Icon(
                Icons.send_rounded,
                color: Theme.of(context).colorScheme.onSurface,
                size: 24.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
