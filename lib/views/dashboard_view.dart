import 'package:flutter/material.dart';
import 'package:simup_up/views/components/bottom-navbar.dart';
import 'package:simup_up/views/home_view.dart';
import 'package:simup_up/views/notifications_view.dart';
import 'package:simup_up/views/routes_view.dart';

import 'map_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late String? userName;
  int _currentIndex = 0;

  void _handleRoutesTap() {
    setState(() {
      _currentIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      HomeView(
        onCurrentStationTap: () {
          _handleRoutesTap();
        },
      ),
      const RoutesView(),
      const NotificationsView(),
      const MapView()
    ];

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BottomNavbar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
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