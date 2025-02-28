import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class AttendanceService {
  static const String _signatureFileName = "virtual_signature.enc";
  static const String _keyStorageKey = "signature_key";
  static const String _queueStorageKey = "attendanceQueue";

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveAttendanceLocally({
    required DateTime attendanceSentDate,
    required int tripNumber,
    required String routeName,
    required String state,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String timeId = DateFormat("jm").format(attendanceSentDate);
    String dayId = DateFormat("yyyy-MM-dd").format(attendanceSentDate);

    String todayKey = 'attendance_${attendanceSentDate.year}_${attendanceSentDate.month}_${attendanceSentDate.day}_trip_$tripNumber';

    await prefs.setString('attendance_last_date', dayId);
    await prefs.setString('attendance_last_time', timeId);
    await prefs.setString('attendance_last_route', routeName);
    await prefs.setInt('attendance_last_trip', tripNumber);
    await prefs.setBool(todayKey, true);

    await prefs.setString('last_attendance_date', dayId);
    await prefs.setString('last_attendance_time', timeId);
    await prefs.setString('attendance_state', state);

    List<String> history = prefs.getStringList('attendance_history') ?? [];

    history.add("$dayId|$routeName");

    // Remove records older than 30 days
    DateTime cutoffDate = attendanceSentDate.subtract(Duration(days: 30));
    history = history.where((record) {
      DateTime recordDate = DateTime.parse(record.split('|')[0]);
      return recordDate.isAfter(cutoffDate);
    }).toList();

    await prefs.setStringList('attendance_history', history);
  }

  // Register attendance using the virtual signature
  Future<void> registerAttendanceFromSignature(int routeNumber, String method) async {
    try {
      Uint8List? encryptedSignature = await _retrieveEncryptedSignature();
      if (encryptedSignature == null) {
        print("❌ No encrypted signature found.");
        return;
      }

      encrypt.Key? key = await _getStoredEncryptionKey();
      if (key == null) {
        print("❌ Encryption key not found.");
        return;
      }

      String? decryptedSignature = _decryptSignature(encryptedSignature, key);
      if (decryptedSignature == null) {
        print("❌ Failed to decrypt signature.");
        return;
      }

      Map<String, dynamic> userInfo = jsonDecode(decryptedSignature);
      String routeName = "route_$routeNumber";  // Define routeName here

      DateTime attendanceSentDate = DateTime.now();
      int tripNumber = getTripNumber(attendanceSentDate);

      await registerAttendance(
        routeName: routeName,
        attendanceSentDate: attendanceSentDate,
        tripNumber: tripNumber,
        method: method,
        userInfo: userInfo,
      );

      await sendQueuedAttendances();
    } catch (e) {
      print("❌ Error processing attendance: $e.");
      await queueAttendanceForLater(routeNumber, method);
    }
  }

  // Register attendance in Firestore
  Future<void> registerAttendance({
    required String routeName, // routeNumber removed
    required DateTime attendanceSentDate,
    required int tripNumber,
    required String method,
    required Map<String, dynamic> userInfo,
    String state = 'sent',
  }) async {
    try {
      String weekId = DateFormat("yyyy-'W'ww").format(attendanceSentDate);
      String dayId = DateFormat("yyyy-MM-dd").format(attendanceSentDate);

      DocumentReference dayDocRef = _firestore
          .collection('attendances')
          .doc(weekId)
          .collection('days')
          .doc(dayId);

      await dayDocRef.collection('records').add({
        'routeName': routeName,
        'attendanceSentDate': attendanceSentDate.toIso8601String(),
        'tripNumber': tripNumber,
        'method': method,
        'userInfo': userInfo,
      });

      await dayDocRef.set({
        'stats': {'totalAttendances': FieldValue.increment(1)},
      }, SetOptions(merge: true));

      await saveAttendanceLocally(
        attendanceSentDate: attendanceSentDate,
        tripNumber: tripNumber,
        routeName: routeName,
        state: state,
      );

      print("✅ Attendance recorded successfully!");
    } catch (e) {
      print("❌ Error saving attendance: $e");
      await queueAttendanceForLater(int.parse(routeName.split('_')[1]), method);
    }
  }

  // Queue attendance when offline
  Future<void> queueAttendanceForLater(int routeNumber, String method) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      Uint8List? encryptedSignature = await _retrieveEncryptedSignature();
      encrypt.Key? key = await _getStoredEncryptionKey();

      if (encryptedSignature == null || key == null) return;

      String? decryptedSignature = _decryptSignature(encryptedSignature, key);
      if (decryptedSignature == null) return;

      DateTime attendanceSentDate = DateTime.now();
      int tripNumber = getTripNumber(attendanceSentDate);
      Map<String, dynamic> userInfo = jsonDecode(decryptedSignature);
      String routeName = "route_$routeNumber";  // Define routeName here

      Map<String, dynamic> queuedAttendance = {
        'routeName': routeName,
        'attendanceSentDate': attendanceSentDate.toIso8601String(),
        'tripNumber': tripNumber,
        'method': method,
        'userInfo': userInfo,
      };

      List<String> queue = prefs.getStringList(_queueStorageKey) ?? [];
      queue.add(jsonEncode(queuedAttendance));
      await prefs.setStringList(_queueStorageKey, queue);

      await saveAttendanceLocally(
        attendanceSentDate: attendanceSentDate,
        tripNumber: tripNumber,
        routeName: routeName,
        state: 'queue',
      );

      print("📌 Attendance queued for later.");
    } catch (e) {
      print("❌ Error queuing attendance: $e");
    }
  }

  // Send all queued attendances
  Future<void> sendQueuedAttendances() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> queue = prefs.getStringList(_queueStorageKey) ?? [];

      if (queue.isEmpty) return;

      for (String attendanceJson in queue) {
        final Map<String, dynamic> attendance = jsonDecode(attendanceJson);
        await registerAttendance(
          routeName: attendance['routeName'],  // No routeNumber needed
          attendanceSentDate: DateTime.parse(attendance['attendanceSentDate']),
          tripNumber: attendance['tripNumber'],
          method: attendance['method'],
          userInfo: attendance['userInfo'],
        );
      }

      await prefs.remove(_queueStorageKey);

      print("✅ All queued attendances sent.");
    } catch (e) {
      print("❌ Error sending queued attendances: $e");
    }
  }

  // Retrieve encrypted virtual signature
  Future<Uint8List?> _retrieveEncryptedSignature() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$_signatureFileName';
      final file = File(filePath);

      if (!file.existsSync()) {
        print("❌ Signature file not found.");
        return null;
      }
      return await file.readAsBytes();
    } catch (e) {
      print("❌ Error retrieving signature: $e");
      return null;
    }
  }

  // Retrieve stored encryption key
  Future<encrypt.Key?> _getStoredEncryptionKey() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? storedKey = prefs.getString(_keyStorageKey);

      if (storedKey == null) {
        print("❌ Encryption key not found.");
        return null;
      }
      return encrypt.Key.fromBase64(storedKey);
    } catch (e) {
      print("❌ Error retrieving encryption key: $e");
      return null;
    }
  }

  // Decrypt virtual signature
  String? _decryptSignature(Uint8List encryptedData, encrypt.Key key) {
    try {
      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
      final iv = encrypt.IV(encryptedData.sublist(0, 16));
      final encryptedBytes = encryptedData.sublist(16);
      final encryptedText = encrypt.Encrypted(encryptedBytes);
      return encrypter.decrypt(encryptedText, iv: iv);
    } catch (e) {
      print("❌ Error decrypting signature: $e");
      return null;
    }
  }

  // Get trip number based on date.
  int getTripNumber(DateTime currentTime) {
    // Define trip schedules (Monday - Friday & Saturday)
    final List<String> weekdayTrips = [
      "05:30", "06:00", "7:00" "08:00", "09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00"
    ];
    final List<String> saturdayTrips = [
      "05:30", "06:00", "7:00" "08:00", "09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00"
    ];

    // Select the correct schedule based on the day
    List<String> tripSchedule = currentTime.weekday == DateTime.saturday
        ? saturdayTrips
        : weekdayTrips;

    // Iterate through the trips to determine the current trip number
    for (int i = 0; i < tripSchedule.length; i++) {
      DateTime tripTime = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        int.parse(tripSchedule[i].split(":")[0]),
        int.parse(tripSchedule[i].split(":")[1]),
      );

      if (currentTime.isBefore(tripTime)) {
        return i + 1; // Trip numbers are 1-based
      }
    }

    // If it's past the last trip time, return the last trip number
    return tripSchedule.length;
  }
}
