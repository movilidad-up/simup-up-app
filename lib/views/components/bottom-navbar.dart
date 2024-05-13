import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/components/nav-button.dart';

class BottomNavbar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  const BottomNavbar({super.key, required this.currentIndex, required this.onTap});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      FeatureDiscovery.discoverFeatures(
        context,
        const <String>{ // Feature ids for every feature that you want to showcase in order.
          'navbar-home-id',
          'navbar-routes-id',
          'navbar-reminder-id',
          'navbar-map-id',
        },
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onBackground,
        borderRadius: BorderRadius.circular(64.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => widget.onTap(0),
              child: DescribedFeatureOverlay(
                featureId: 'navbar-home-id',
                tapTarget: NavButton(
                  icon: Icons.home_rounded,
                  selected: true,
                ),
                title: Text(
                    AppLocalizations.of(context)!.tourHome,
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.background
                  ),
                ),
                description: Text(
                  AppLocalizations.of(context)!.tourHomeDescription,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inter',
                      color: Theme.of(context).colorScheme.background
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                targetColor: Colors.white,
                enablePulsingAnimation: false,
                textColor: Colors.white,
                child: NavButton(
                  icon: Icons.home_rounded,
                  selected: widget.currentIndex == 0,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => widget.onTap(1),
              child: DescribedFeatureOverlay(
                featureId: 'navbar-routes-id',
                tapTarget: NavButton(
                  icon: Icons.route_rounded,
                  selected: true,
                ),
                overflowMode: OverflowMode.extendBackground,
                title: Text(
                    AppLocalizations.of(context)!.tourRoutes,
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.background
                  ),
                ),
                description: Text(
                  AppLocalizations.of(context)!.tourRoutesDescription,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inter',
                      color: Theme.of(context).colorScheme.background
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                targetColor: Colors.white,
                enablePulsingAnimation: false,
                textColor: Colors.white,
                child: NavButton(
                  icon: Icons.route_rounded,
                  selected: widget.currentIndex == 1,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => widget.onTap(2),
              child: DescribedFeatureOverlay(
                featureId: 'navbar-reminder-id',
                tapTarget: NavButton(
                  icon: Icons.notifications_rounded,
                  selected: true,
                ),
                overflowMode: OverflowMode.extendBackground,
                title: Text(
                  AppLocalizations.of(context)!.tourReminders,
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.background
                  ),
                ),
                description: Text(
                    AppLocalizations.of(context)!.tourRemindersDescription,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inter',
                      color: Theme.of(context).colorScheme.background
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                targetColor: Colors.white,
                enablePulsingAnimation: false,
                textColor: Colors.white,
                child: NavButton(
                  icon: Icons.notifications_rounded,
                  selected: widget.currentIndex == 2,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => widget.onTap(3),
              child: DescribedFeatureOverlay(
                featureId: 'navbar-map-id',
                tapTarget: NavButton(
                  icon: Icons.map_rounded,
                  selected: true,
                ),
                overflowMode: OverflowMode.extendBackground,
                title: Text(
                  AppLocalizations.of(context)!.tourMap,
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.background
                  ),
                ),
                description: Text(
                  AppLocalizations.of(context)!.tourMapDescription,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inter',
                      color: Theme.of(context).colorScheme.background
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                targetColor: Colors.white,
                enablePulsingAnimation: false,
                textColor: Colors.white,
                child: NavButton(
                  icon: Icons.map_rounded,
                  selected: widget.currentIndex == 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}