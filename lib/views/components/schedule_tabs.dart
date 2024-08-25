import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/components/custom_tab_bar.dart';

class ScheduleTabs extends StatefulWidget {
  const ScheduleTabs({super.key});

  @override
  _ScheduleTabsState createState() => _ScheduleTabsState();
}

class _ScheduleTabsState extends State<ScheduleTabs> {
  int _selectedTabIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 24.0, right: 24.0),
          child: CustomTabBar(
            tabs: [
              AppLocalizations.of(context)!.routeOne,
              AppLocalizations.of(context)!.routeTwo
            ],
            selectedIndex: _selectedTabIndex,
            onTabTapped: _onTabTapped,
          ),
        ),
        Expanded(
          child: _selectedTabIndex == 0
              ? _builSchedulesOne()
              : _builSchedulesTwo(),
        ),
      ],
    );
  }

  Widget CustomTableTitle(String text, Decoration rowDecoration) {
    return DecoratedBox(
      decoration: rowDecoration,
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Text(
            text,
            style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                height: 1.4
            ),
            textScaler: const TextScaler.linear(1.0),
          )),
    );
  }

  Widget CustomTablePair(String textLeft, String textRight) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              textLeft,
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.0,
                  color: Theme.of(context).colorScheme.onSurface),
              textScaler: const TextScaler.linear(1.0),
            ),
            Text(
              textRight,
              textAlign: TextAlign.end,
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.0,
                  color: Theme.of(context).colorScheme.onSurface),
              textScaler: const TextScaler.linear(1.0),
            ),
          ],
        ));
  }

  Widget _builSchedulesOne() {
    return Padding(
      padding: const EdgeInsets.only(
          top: 16.0, right: 24.0, left: 24.0, bottom: 24.0),
      child: SingleChildScrollView(
        child: DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: const Color(0xFFE9E9E7)),
              borderRadius: BorderRadius.circular(24.0),
              color: Theme.of(context).colorScheme.surface),
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTableTitle(
                    "${AppLocalizations.of(context)!.routeOne} - ${AppLocalizations.of(context)!.mondayToFridays}",
                    const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0)),
                      color: Color(0xFFE9E9E7),
                    )),
                CustomTablePair(AppLocalizations.of(context)!.station, AppLocalizations.of(context)!.arrivalTimes),
                const Divider(
                  color: Color(0xFFE9E9E7),
                ),
                CustomTablePair("El Palustre",
                    "05:30 A.M.\n07:00 A.M.\n09:00 A.M.\n11:00 A.M.\n01:00 P.M.\n03:00 P.M.\n05:00 P.M."),
                const Divider(
                  color: Color(0xFFE9E9E7),
                ),
                CustomTablePair("Sede Villa del Rosario",
                    "06:10 A.M.\n08:10 A.M.\n10:10 A.M.\n12:10 P.M.\n02:10 P.M.\n04:10 P.M.\n06:10 P.M."),
                CustomTableTitle(
                    "${AppLocalizations.of(context)!.routeOne} - ${AppLocalizations.of(context)!.saturdays}",
                    const BoxDecoration(
                      color: Color(0xFFE9E9E7),
                    )),
                CustomTablePair(AppLocalizations.of(context)!.station, AppLocalizations.of(context)!.arrivalTimes),
                const Divider(
                  color: Color(0xFFE9E9E7),
                ),
                CustomTablePair("El Palustre",
                    "05:30 A.M.\n07:00 A.M.\n09:00 A.M.\n11:00 A.M.\n01:00 P.M.\n03:00 P.M."),
                const Divider(
                  color: Color(0xFFE9E9E7),
                ),
                CustomTablePair("Sede Villa del Rosario",
                    "06:10 A.M.\n08:10 A.M.\n10:10 A.M.\n12:10 P.M.\n02:10 P.M."),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _builSchedulesTwo() {
    return Padding(
      padding: const EdgeInsets.only(
          top: 16.0, right: 24.0, left: 24.0, bottom: 24.0),
      child: SingleChildScrollView(
        child: DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: const Color(0xFFE9E9E7)),
              borderRadius: BorderRadius.circular(24.0),
              color: Theme.of(context).colorScheme.surface),
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTableTitle(
                    "${AppLocalizations.of(context)!.routeTwo} - ${AppLocalizations.of(context)!.mondayToFridays}",
                    const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0)),
                      color: Color(0xFFE9E9E7),
                    )),
                CustomTablePair(AppLocalizations.of(context)!.station, AppLocalizations.of(context)!.arrivalTimes),
                const Divider(
                  color: Color(0xFFE9E9E7),
                ),
                CustomTablePair("Sede Villa del Rosario",
                    "08:10 A.M.\n10:10 A.M.\n12:10 A.M.\n02:10 A.M.\n04:10 P.M.\n06:10 A.M.\n05:00 P.M."),
                const Divider(
                  color: Color(0xFFE9E9E7),
                ),
                CustomTablePair("CREAD",
                    "09:15 A.M.\n11:15 A.M.\n01:15 A.M.\n03:15 P.M.\n05:15 P.M."),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
