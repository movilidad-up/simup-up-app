import 'dart:async';
import 'dart:math';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter/services.dart';

class BeaconChecker {
  static final List<String> validBeaconMACs = [
    "C8:13:C2:2A:E9:A1", // Add more MAC addresses as needed
  ];

  static const int txPower = -59; // Default Tx Power at 1m
  static const double maxAllowedDistance = 12.0; // Max 12 meters (bus length)
  static const double environmentalFactor = 6.0; // Inside a bus (requires testing)

  static Future<void> initializeBeaconScanning() async {
    try {
      await FlutterBluePlus.startScan();
    } on PlatformException catch (e) {
      print("Beacon scanning initialization failed: ${e.message}");
    }
  }

  static Future<bool> isNearValidBeacon() async {
    Completer<bool> beaconFound = Completer<bool>();

    await initializeBeaconScanning(); // Ensures scanning is started

    StreamSubscription? scanSubscription;
    scanSubscription = FlutterBluePlus.scanResults.listen((scanResults) {
      for (ScanResult result in scanResults) {
        String macAddress = result.device.id.id.toUpperCase();
        int rssi = result.rssi;

        if (validBeaconMACs.contains(macAddress)) {
          double distance = estimateDistance(rssi);
          // print("✅ Valid beacon detected: $macAddress | RSSI: $rssi | Distance: ${distance.toStringAsFixed(2)}m");

          if (distance <= maxAllowedDistance) {
            beaconFound.complete(true);
          } else {
            // print("🚫 Too far from the bus! Distance: ${distance.toStringAsFixed(2)}m.");
            beaconFound.complete(false);
          }

          scanSubscription?.cancel();
          return;
        }
      }
    });

    Future.delayed(Duration(seconds: 6), () {
      if (!beaconFound.isCompleted) {
        // print("❌ No beacon detected, stopping scan.");
        beaconFound.complete(false);
      }
      scanSubscription?.cancel();
    });

    return beaconFound.future;
  }

  static double estimateDistance(int rssi) {
    return pow(10, (txPower - rssi) / (10 * environmentalFactor)).toDouble();
  }
}
