import 'dart:async';
import 'dart:math';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter/services.dart';
import 'package:simup_up/enums/enums.dart';

class BeaconChecker {
  static int detectedRouteNumber = 1;

  static final Map<String, int> beaconRouteMap = {
    "C8:13:C2:2A:E9:A1": 1,
    "AB:CD:EF:12:34:56": 2,
  };

  static const int txPower = -59; // Default Tx Power at 1m
  static const double maxAllowedDistance = 12.0; // Max 12 meters (bus length)
  static const double environmentalFactor = 6.0; // Inside a bus (requires testing)

  static Future<bool> isNearValidBeacon() async {
    RadarStatus status = await checkBeaconStatus();
    return status == RadarStatus.sending;
  }

  static Future<RadarStatus> checkBeaconStatus() async {

    // Check if bluetooth is enabled.

    bool isBluetoothOn = await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on;
    if (!isBluetoothOn) {
      return RadarStatus.bluetoothDisabled;
    }

    // Initialize scanning and update status to scanning.

    await initializeBeaconScanning();
    Completer<RadarStatus> statusCompleter = Completer<RadarStatus>();

    StreamSubscription? scanSubscription;
    scanSubscription = FlutterBluePlus.scanResults.listen((scanResults) {
      for (ScanResult result in scanResults) {
        String macAddress = result.device.id.id.toUpperCase();
        int rssi = result.rssi;

        if (beaconRouteMap.containsKey(macAddress)) {
          double distance = estimateDistance(rssi);

          if (distance <= maxAllowedDistance) {
            scanSubscription?.cancel();
            detectedRouteNumber = beaconRouteMap[macAddress]!;
            statusCompleter.complete(RadarStatus.sending);
            return;
          } else {
            scanSubscription?.cancel();
            statusCompleter.complete(RadarStatus.tooFar);
            return;
          }
        }
      }
    });

    Future.delayed(Duration(seconds: 6), () {
      if (!statusCompleter.isCompleted) {
        scanSubscription?.cancel();
        statusCompleter.complete(RadarStatus.noSignal);
      }
    });

    return statusCompleter.future;
  }

  static Future<void> initializeBeaconScanning() async {
    try {
      await FlutterBluePlus.startScan();
    } on PlatformException catch (e) {
      print("Beacon scanning initialization failed: \${e.message}");
    }
  }

  static double estimateDistance(int rssi) {
    return pow(10, (txPower - rssi) / (10 * environmentalFactor)).toDouble();
  }
}
