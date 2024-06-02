import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:simup_up/views/components/bottom-navbar.dart';
import 'package:simup_up/views/home_view.dart';
import 'package:simup_up/views/notifications_view.dart';
import 'package:simup_up/views/routes_view.dart';
import 'package:simup_up/views/schedules_view.dart';
import 'package:simup_up/views/utils/custom-page-router.dart';
import 'package:simup_up/views/utils/station-model.dart';
import 'package:simup_up/views/utils/update-observable.dart';
import 'map_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late String? userName;
  int _currentIndex = 0;
  bool isCronRunning = false;
  late ScheduledTask cronTask;
  late final cron = Cron();
  late final UpdateObservable updateObservable;

  @override
  void initState() {
    updateObservable = UpdateObservable();
    _handleTimeUpdate();
    super.initState();
  }

  void _handleRoutesTap() {
    setState(() {
      _currentIndex = 1;
    });
  }

  void _handleTimeUpdate() {
    final shouldStartCron = _currentIndex <= 1 && !isCronRunning;

    if (shouldStartCron) {
      isCronRunning = true;
      cronTask = cron.schedule(Schedule.parse('*/1 * * * *'), () async {
        _updateCurrentStation(_currentIndex);
      });
    } else if (isCronRunning) {
      cronTask.cancel();
      isCronRunning = false;
    }
  }

  void _updateCurrentStation(int selectedTabIndex) {
    setState(() {
      StationModel.getStationIntervals(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      HomeView(
        onCurrentStationTap: () {
          _handleRoutesTap();
        },
        onSchedulesTap: () {
          Navigator.of(context).push(CustomPageRoute(const SchedulesView()));
        },
        updateObservable: updateObservable,
      ),
      const RoutesView(),
      const NotificationsView(),
      const MapView(),
    ];

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BottomNavbar(
              context: context,
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
                _handleTimeUpdate();
              },
            ),
          ),
        ),
        body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
        child: _screens[_currentIndex])
    );
  }
}