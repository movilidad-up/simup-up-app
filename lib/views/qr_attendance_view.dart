import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/utils/attendance_service.dart';

class QrAttendanceView extends StatefulWidget {
  const QrAttendanceView({Key? key}) : super(key: key);

  @override
  State<QrAttendanceView> createState() => _QrAttendanceViewState();
}

class _QrAttendanceViewState extends State<QrAttendanceView> {
  String scanResult = "Escanea un código QR";
  int routeNumber = 1;
  bool isScanning = true;

  Future<void> _processQRCode(String rawValue) async {
    try {
      final Map<String, dynamic> data = jsonDecode(rawValue);

      if (data["type"] == "movilidad_qr" && data.containsKey("route")) {
        routeNumber = int.tryParse(data["route"]) ?? -1;

        if (routeNumber >= 1 && routeNumber <= 3) {
          setState(() {
            scanResult = "Asistencia registrada en la ruta $routeNumber";
            isScanning = false;
          });

          bool hasInternet = await checkInternetConnection();

          if (hasInternet) {
            bool success = await sendAttendance();
            if (!success) {
              await queueAttendanceForLater(); // Fallback if sending fails
            }
          } else {
            await queueAttendanceForLater();
          }
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
      return true;
    } catch (e) {
      print("❌ Error sending attendance: $e");
      return false;
    }
  }

  Future<void> queueAttendanceForLater() async {
    try {
      await AttendanceService().queueAttendanceForLater(routeNumber, "qr_code");
      print("📌 Attendance stored for later.");
    } catch (e) {
      print("❌ Error queuing attendance: $e");
    }
  }

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
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 48,
                          height: MediaQuery.of(context).size.width - 48,
                          child: MobileScanner(
                            onDetect: (capture) {
                              if (isScanning && capture.barcodes.isNotEmpty) {
                                setState(() => isScanning = false);
                                _processQRCode(capture.barcodes.first.rawValue ?? "");
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("Resultado: $scanResult", style: TextStyle(fontSize: 18)),
                        ),
                        ElevatedButton(
                          onPressed: () => setState(() => isScanning = true),
                          child: Text("Escanear otro QR"),
                        ),
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
