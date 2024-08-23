import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simup_up/views/components/user_zones.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:simup_up/views/utils/shared_prefs.dart';

class LocationChip extends StatefulWidget {
  const LocationChip({super.key});

  @override
  State<LocationChip> createState() => _LocationChipState();
}

class _LocationChipState extends State<LocationChip> {
  int userZoneIndex = 0;

  @override
  void initState() {
    getUserZoneIndex();
    super.initState();
  }

  void getUserZoneIndex() {
    userZoneIndex = SharedPrefs().prefs.getInt('userZone')!;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    String getUserZoneMessage() {
      String userZoneName = UserZones.zoneNames(context).elementAt(userZoneIndex);
      String zoneMessage = AppLocalizations.of(context)!.isWithinYourZone;
      return "$zoneMessage $userZoneName";
    }

    return SizedBox(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Theme.of(context).colorScheme.onSurface,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.directions_bus_rounded, size: 16.0, color: Colors.white,),
              HorizontalSpacing(4.0),
              SizedBox(
                height: 20.0,
                width: screenWidth * 0.5,
                child: Marquee(
                  text: getUserZoneMessage(),
                  style: TextStyle(
                       fontSize: 14.0,
                       color: Theme.of(context).colorScheme.surface,
                     ),
                  textScaleFactor: 1.0,
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  blankSpace: 16.0,
                  velocity: 18.0,
                  startPadding: 0.0,
                  accelerationDuration: const Duration(seconds: 1),
                  accelerationCurve: Curves.linear,
                  decelerationDuration: const Duration(milliseconds: 500),
                  decelerationCurve: Curves.easeOut,
                  pauseAfterRound: const Duration(seconds: 2),
                  showFadingOnlyWhenScrolling: false,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
