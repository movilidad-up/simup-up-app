import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simup_up/views/components/attendance-card.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import 'components/action_card.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  List<Map<String, String>> _filteredAttendances = [];

  @override
  void initState() {
    super.initState();
    _loadAttendances();
  }

  Future<void> _loadAttendances() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? storedAttendances = prefs.getStringList('attendance_history');

    if (storedAttendances == null) return;

    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    List<Map<String, String>> filtered = [];

    for (String record in storedAttendances) {
      List<String> parts = record.split('|');
      if (parts.length < 2) continue;

      DateTime recordDate = DateTime.parse(parts[0]);

      String? storedTime = prefs.getString('attendance_last_time');
      String formattedTime = storedTime ?? DateFormat("hh:mm a").format(recordDate);

      String formattedRoute = parts[1].replaceAll('_', '');
      formattedRoute = formattedRoute.replaceFirst('route', '');

      if (recordDate.year == currentYear && recordDate.month == currentMonth) {
        filtered.add({
          'date': "${DateFormat("dd/MM/yyyy").format(recordDate)}",
          'time': formattedTime,
          'routeNumber': formattedRoute,
        });
      }
    }

    setState(() {
      _filteredAttendances = filtered;
    });
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
                AppLocalizations.of(context)!.history,
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
                          AppLocalizations.of(context)!.history,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          AppLocalizations.of(context)!.historyDescription,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.myRecentAttendance,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          textScaler: const TextScaler.linear(1.0),
                        ),
                        VerticalSpacing(16.0),
                        if (_filteredAttendances.isEmpty)
                          Text(AppLocalizations.of(context)!.noAttendanceRecords),
                        for (var attendance in _filteredAttendances) ...[
                          AttendanceCard(
                            date: "${attendance['date']!} ${AppLocalizations.of(context)!.at} ${attendance['time']!}",
                            route: "${AppLocalizations.of(context)!.route} ${attendance['routeNumber']!}",
                          ),
                          VerticalSpacing(8.0),
                        ],
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
