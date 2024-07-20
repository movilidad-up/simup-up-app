import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simup_up/views/components/animated_rectangle.dart';
import 'package:simup_up/views/components/current_station_card.dart';
import 'package:simup_up/views/components/schedules_card.dart';
import 'package:simup_up/views/components/status_card.dart';
import 'package:simup_up/views/settings_view.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/utils/custom-page-router.dart';
import 'package:simup_up/views/utils/update-observable.dart';

class HomeView extends StatefulWidget {
  final VoidCallback onCurrentStationTap;
  final VoidCallback onSchedulesTap;
  final UpdateObservable updateObservable;

  const HomeView({super.key, required this.onCurrentStationTap, required this.updateObservable, required this.onSchedulesTap});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late String? userName;

  @override
  void initState() {
    userName = '';
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
        child: SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 32.0, bottom: 32.0, left: 24.0, right: 24.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '${AppLocalizations.of(context)!.hello}, ${userName ?? AppLocalizations.of(context)!.guestTitle}!',
                              style: Theme.of(context).textTheme.displayLarge,
                              textAlign: TextAlign.start,
                              textScaler: const TextScaler.linear(1.0),
                          ),
                          VerticalSpacing(8.0),
                          Text(AppLocalizations.of(context)!.awesomeDay,
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.start,
                              textScaler: const TextScaler.linear(1.0),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      enableFeedback: false,
                      onPressed: () {
                        Navigator.of(context)
                           .push(CustomPageRoute(const SettingsView()));
                      },
                      icon: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.settings,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 24.0,
                        ),
                      ),
                    ),
                  ],
                ),
                VerticalSpacing(24.0),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate([
                          const StatusCard(),
                          VerticalSpacing(16.0),
                          SchedulesCard(
                            onSchedulesTap: widget.onSchedulesTap,
                          ),
                          VerticalSpacing(16.0),
                          CurrentStationCard(
                            isRouteOne: true,
                            onCurrentStationTap: widget.onCurrentStationTap,
                            updateObservable: widget.updateObservable,
                          ),
                          VerticalSpacing(16.0),
                          CurrentStationCard(
                            isRouteOne: false,
                            onCurrentStationTap: widget.onCurrentStationTap,
                            updateObservable: widget.updateObservable,
                          ),
                        ]),
                      ),
                    ]
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}