import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:simup_up/views/components/nav-button.dart';
import 'package:simup_up/views/utils/shared_prefs.dart';

class BottomNavbar extends StatefulWidget {
  final BuildContext context;
  final int currentIndex;
  final Function(int) onTap;
  const BottomNavbar({super.key, required this.currentIndex, required this.onTap, required this.context});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  bool isTourCompleted = true;
  GlobalKey homeNavKey = GlobalKey();
  GlobalKey routesNavKey = GlobalKey();
  GlobalKey attendanceNavKey = GlobalKey();
  GlobalKey remindersNavKey = GlobalKey();
  GlobalKey mapNavKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _checkTourCompletion(widget.context);
  }

  void _checkTourCompletion(BuildContext context) async {
    try {
      bool? isTourCompleted = SharedPrefs().prefs.getBool('tourCompleted');

      if (isTourCompleted == null || !isTourCompleted) {
        _startShowcase();
      }
    } catch (e) {
      print('Error while checking tour completion: $e');
    }
  }

  void _startShowcase() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ShowCaseWidget.of(widget.context).startShowCase(
        [homeNavKey, routesNavKey, attendanceNavKey, remindersNavKey, mapNavKey],
      );
    });
  }

  void _updateTourCompletion() async {
    await SharedPrefs().prefs.setBool('tourCompleted', true);
    await SharedPrefs().reload();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(64.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Showcase(
              key: homeNavKey,
              title: AppLocalizations.of(context)!.tourHome,
              tooltipBorderRadius: BorderRadius.circular(24.0),
              tooltipPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              targetPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
              targetBorderRadius: BorderRadius.circular(32.0),
              tooltipBackgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              titlePadding: const EdgeInsets.only(bottom: 8.0),
              scaleAnimationCurve: Curves.ease,
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.onSurface,
              ),
              descTextStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.tertiary,
              ),
              description: AppLocalizations.of(context)!.tourHomeDescription,
              child: GestureDetector(
                onTap: () => widget.onTap(0),
                child: NavButton(
                  icon: Icons.home_rounded,
                  selected: widget.currentIndex == 0,
                ),
              ),
            ),
            Showcase(
              key: routesNavKey,
              title: AppLocalizations.of(context)!.tourRoutes,
              tooltipBorderRadius: BorderRadius.circular(24.0),
              tooltipPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              targetPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
              targetBorderRadius: BorderRadius.circular(32.0),
              tooltipBackgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              titlePadding: const EdgeInsets.only(bottom: 8.0),
              scaleAnimationCurve: Curves.ease,
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.onSurface,
              ),
              descTextStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.tertiary,
              ),
              description: AppLocalizations.of(context)!.tourRoutesDescription,
              child: GestureDetector(
                onTap: () => widget.onTap(1),
                child: NavButton(
                  icon: Icons.route_rounded,
                  selected: widget.currentIndex == 1,
                ),
              ),
            ),
            Showcase(
              key: attendanceNavKey,
              title: AppLocalizations.of(context)!.tourAttendance,
              tooltipBorderRadius: BorderRadius.circular(24.0),
              tooltipPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              targetPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
              targetBorderRadius: BorderRadius.circular(32.0),
              tooltipBackgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              titlePadding: const EdgeInsets.only(bottom: 8.0),
              scaleAnimationCurve: Curves.ease,
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.onSurface,
              ),
              descTextStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.tertiary,
              ),
              description: AppLocalizations.of(context)!.tourAttendanceDescription,
              child: GestureDetector(
                onTap: () => widget.onTap(2),
                child: NavButton(
                  icon: Icons.draw_rounded,
                  selected: widget.currentIndex == 2,
                ),
              ),
            ),
            Showcase(
              key: remindersNavKey,
              title: AppLocalizations.of(context)!.tourReminders,
              tooltipBorderRadius: BorderRadius.circular(24.0),
              tooltipPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              targetPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
              targetBorderRadius: BorderRadius.circular(32.0),
              tooltipBackgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              titlePadding: const EdgeInsets.only(bottom: 8.0),
              scaleAnimationCurve: Curves.ease,
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.onSurface,
              ),
              descTextStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.tertiary,
              ),
              description: AppLocalizations.of(context)!.tourRemindersDescription,
              child: GestureDetector(
                onTap: () => widget.onTap(3),
                child: NavButton(
                  icon: Icons.notifications_rounded,
                  selected: widget.currentIndex == 3,
                ),
              ),
            ),
            Showcase(
              key: mapNavKey,
              title: AppLocalizations.of(context)!.tourMap,
              tooltipBorderRadius: BorderRadius.circular(24.0),
              tooltipPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              targetPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
              targetBorderRadius: BorderRadius.circular(32.0),
              tooltipBackgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              titlePadding: const EdgeInsets.only(bottom: 8.0),
              scaleAnimationCurve: Curves.ease,
              onTargetClick: _updateTourCompletion,
              onBarrierClick: _updateTourCompletion,
              onToolTipClick: _updateTourCompletion,
              disposeOnTap: true,
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.onSurface,
              ),
              descTextStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.tertiary,
              ),
              description: AppLocalizations.of(context)!.tourMapDescription,
              child: GestureDetector(
                onTap: () => widget.onTap(4),
                child: NavButton(
                  icon: Icons.map_rounded,
                  selected: widget.currentIndex == 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}