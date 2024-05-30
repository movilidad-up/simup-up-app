import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherChecker {
  final String apiKey = const String.fromEnvironment('WEATHER_API_KEY', defaultValue: 'default_api_key');

  WeatherChecker();

  Future<bool> isRainy() async {
    String location = "Cucuta";
    final apiUrl =
        'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$location&aqi=no';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final condition =
        data['current']['condition']['text'].toLowerCase();
        print("Weather retrieved: $condition");
        return condition.contains('rain') || condition.contains('drizzle');
      } else {
        print('Failed to load weather data: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error loading weather data: $error');
      return false;
    }
  }

  Future<bool> shouldRun() async {
    // Get current time
    final now = TimeOfDay.now();

    // Convert current time to DateTime
    final currentDateTime = DateTime.now();
    final currentTime = DateTime(
      currentDateTime.year,
      currentDateTime.month,
      currentDateTime.day,
      now.hour,
      now.minute,
    );

    // Define time intervals
    final intervals = [
      // 5:30 A.M. - 10:00 A.M.
      {'start': const TimeOfDay(hour: 5, minute: 30), 'end': const TimeOfDay(hour: 10, minute: 0)},
      // 10:00 A.M. - 12:00 P.M.
      {'start': const TimeOfDay(hour: 10, minute: 0), 'end': const TimeOfDay(hour: 12, minute: 0)},
      // 12:00 P.M. - 3:00 P.M.
      {'start': const TimeOfDay(hour: 12, minute: 0), 'end': const TimeOfDay(hour: 15, minute: 0)},
      // 3:00 P.M. - 5:00 P.M.
      {'start': const TimeOfDay(hour: 15, minute: 0), 'end': const TimeOfDay(hour: 17, minute: 0)},
    ];

    // Check if current time is within any of the intervals
    bool withinInterval = false;
    for (var interval in intervals) {
      final startTime = interval['start']!;
      final endTime = interval['end']!;
      if (isTimeWithinRange(currentTime, startTime, endTime)) {
        withinInterval = true;
        break;
      }
    }

    if (!withinInterval) {
      print('Current time is not within the allowed intervals.');
      return false;
    }

    // Check if current day is Monday-Saturday
    if (currentDateTime.weekday == DateTime.sunday) {
      print('Today is Sunday. Not running the function.');
      return false;
    }

    // Check if the function has already been run 4 times today
    final lastRunKey = '${currentDateTime.year}-${currentDateTime.month}-${currentDateTime.day}';
    final prefs = await SharedPreferences.getInstance();
    int runCount = prefs.getInt(lastRunKey) ?? 0;
    if (runCount >= 4) {
      print('Function has already been run 4 times today.');
      return false;
    }

    // Increment run count
    prefs.setInt(lastRunKey, runCount + 1);

    // Function should run based on constraints
    return true;
  }

  bool isTimeWithinRange(
      DateTime time,
      TimeOfDay startTime,
      TimeOfDay endTime,
      ) {
    final startTimeDateTime = DateTime(
      time.year,
      time.month,
      time.day,
      startTime.hour,
      startTime.minute,
    );
    final endTimeDateTime = DateTime(
      time.year,
      time.month,
      time.day,
      endTime.hour,
      endTime.minute,
    );
    return time.isAfter(startTimeDateTime) && time.isBefore(endTimeDateTime);
  }
}
