import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:simup_up/enums/enums.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/attendance_log_view.dart';
import 'package:simup_up/views/components/primary_button.dart';
import 'package:simup_up/views/dashboard_view.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:simup_up/views/utils/attendance_service.dart';
import 'package:simup_up/views/utils/custom-page-router.dart';
import 'package:simup_up/views/utils/status_radar_utils.dart';
import 'custom_toast.dart';

class QrStatusRadar extends StatefulWidget {
  const QrStatusRadar({Key? key}) : super(key: key);

  @override
  State<QrStatusRadar> createState() => _QrStatusRadarState();
}

class _QrStatusRadarState extends State<QrStatusRadar> {
  RadarStatus currentStatus = RadarStatus.ready;
  String scanResult = "Escanea un código QR";
  int routeNumber = 1;
  int _countdown = 5;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
      MaterialPageRoute(builder: (context) => const AttendanceLogView(methodId: 'qr_code')),
    );
  }

  Future<void> _handleAttendanceSubmission() async {
    bool hasInternet = await checkInternetConnection();

    if (hasInternet) {
      await sendAttendance();
      setState(() {
        currentStatus = RadarStatus.success;
      });
    } else {
      await queueAttendanceForLater();
      setState(() {
        currentStatus = RadarStatus.successQueue;
      });
    }
  }

  Future<void> _processQRCode(String rawValue) async {
    try {
      final Map<String, dynamic> data = jsonDecode(rawValue);

      if (data["type"] == "movilidad_qr" && data.containsKey("route")) {
        routeNumber = int.tryParse(data["route"]) ?? -1;

        if (routeNumber >= 1 && routeNumber <= 3) {
          setState(() {
            scanResult = "Asistencia registrada en la ruta $routeNumber";
            currentStatus = RadarStatus.sending;
          });

          _handleAttendanceSubmission();
        } else {
          _updateScanResult("Número de ruta inválido");
        }
      } else {
        _updateScanResult("QR no válido");
      }
    } catch (e) {
      _updateScanResult("Error al leer el QR");
    }
  }

  void _updateScanResult(String message) {
    setState(() => scanResult = message);
  }

  Future<bool> checkInternetConnection() async {
    try {
      return await InternetConnection().hasInternetAccess;
    } catch (e) {
      print("⚠️ Error checking internet connection: $e");
      return false;
    }
  }

  Future<bool> sendAttendance() async {
    try {
      await AttendanceService().registerAttendanceFromSignature(routeNumber, "qr_code");
      CustomToast.buildToast(
        context,
        const Color(0xFF44B300),
        AppLocalizations.of(context)!.beaconAttendanceSent,
        AppLocalizations.of(context)!.beaconAttendanceSentInfo,
        Icons.check_circle,
      );
      _startCountdown();
      return true;
    } catch (e) {
      print("❌ Error sending attendance: $e");
      return false;
    }
  }

  Future<void> queueAttendanceForLater() async {
    try {
      await AttendanceService().queueAttendanceForLater(routeNumber, "qr_code");
      CustomToast.buildToast(
        context,
        const Color(0xFFFFA500),
        "Attendance Queued",
        "Your attendance will be sent when online.",
        Icons.schedule,
      );
      _startCountdown();
      print("📌 Attendance stored for later.");
    } catch (e) {
      print("❌ Error queuing attendance: $e");
    }
  }

  bool _isSendStatus() {
    if (currentStatus == RadarStatus.sending || currentStatus == RadarStatus.success || currentStatus == RadarStatus.successQueue) {
      return true;
    } else {
      return false;
    }
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

    return Column(
      children: [
        _isSendStatus() ? DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(width: 1.0, color: const Color(0xFFE9E9E7)),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 48,
            height: MediaQuery.of(context).size.width - 48,
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  isProcessing ? CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondaryContainer,       // Change color
                    strokeWidth: 4.0,        // Adjust thickness
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary), // Custom animation color
                  ) : Icon(
                    Icons.check_rounded,
                    size: 32.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  VerticalSpacing(16.0),
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
                ],
              ),
            ),
          ),
        ) : SizedBox(
          width: MediaQuery.of(context).size.width - 48,
          height: MediaQuery.of(context).size.width - 48,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
            child: MobileScanner(
              onDetect: (capture) {
                if (currentStatus == RadarStatus.ready && capture.barcodes.isNotEmpty) {
                  setState(() => currentStatus = RadarStatus.scanning);
                  _processQRCode(capture.barcodes.first.rawValue ?? "");
                }
              },
            ),
          ),
        ),
        if (isSuccess) ...[
          VerticalSpacing(16.0),
          PrimaryButton(
              onButtonPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AttendanceLogView(methodId: 'qr_code')),
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
        ] else ...[
          VerticalSpacing(16.0),
          Text(
            scanResult,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ],
    );
  }
}
