import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static final SharedPrefs _instance = SharedPrefs._internal();
  late SharedPreferences prefs;

  factory SharedPrefs() {
    return _instance;
  }

  SharedPrefs._internal();

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> reload() async {
    prefs = await SharedPreferences.getInstance();
  }

  // Clear all preferences if needed
  Future<void> clearAll() async {
    await prefs.clear();
  }
}