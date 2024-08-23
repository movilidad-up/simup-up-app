import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/enums/enums.dart';
import 'package:simup_up/views/components/location_chip.dart';
import 'package:simup_up/views/components/user_stations.dart';
import 'package:simup_up/views/components/user_zones.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:simup_up/views/utils/shared_prefs.dart';

class StationCard extends StatefulWidget {
  final String name;
  final String arrivalInfo;
  final int stationIndex;
  final bool isCurrentStation;
  final VoidCallback onTap;
  const StationCard({super.key, required this.name, required this.arrivalInfo, required this.onTap, required this.isCurrentStation, required this.stationIndex});

  @override
  State<StationCard> createState() => _StationCardState();
}

class _StationCardState extends State<StationCard> {
  bool isWithinUserZone = false;

  @override
  void initState() {
    _isWithinUserZone();
    super.initState();
  }

  void _isWithinUserZone() {
    try {
      int? userZoneIndex = SharedPrefs().prefs.getInt('userZone');
      Zone userZone = UserZones.zoneList.elementAt(userZoneIndex!);

      if (userZoneIndex != null) {
        List<Zone> zones = UserStations.stationRoutes.elementAt(widget.stationIndex);
        isWithinUserZone = zones.contains(userZone);
      }
    } catch (e) {
      print('Error while retrieving user zone: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String enabledStationLineAsset = Theme.of(context).colorScheme.brightness == Brightness.light ? 'assets/images/illustrations/station-line-enabled.svg' : 'assets/images/illustrations/station-line-enabled-dark.svg';
    String disabledStationLineAsset = Theme.of(context).colorScheme.brightness == Brightness.light ? 'assets/images/illustrations/station-line-disabled.svg' : 'assets/images/illustrations/station-line-disabled-dark.svg';
    double screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: widget.onTap,
      child: SizedBox(
        width: screenWidth,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: widget.isCurrentStation ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.surface,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                    widget.isCurrentStation ? enabledStationLineAsset : disabledStationLineAsset,
                    fit: BoxFit.fill,
                ),
                HorizontalSpacing(0.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                      textScaler: const TextScaler.linear(1.0),
                    ),
                    VerticalSpacing(4.0),
                    Text(
                      widget.isCurrentStation
                          ? AppLocalizations.of(context)!.currentStation + widget.arrivalInfo
                          : AppLocalizations.of(context)!.arrivalTime + widget.arrivalInfo,
                      style: TextStyle(
                          fontFamily: 'Inter',
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 12.0,
                          fontWeight: FontWeight.normal
                      ),
                      textScaler: const TextScaler.linear(1.0),
                    ),
                    VerticalSpacing(4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.moreInfo,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500
                          ),
                          textScaler: const TextScaler.linear(1.0),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20.0,
                        )
                      ],
                    ),
                    isWithinUserZone ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VerticalSpacing(4.0),
                        const LocationChip()
                      ],
                    ) : const SizedBox()
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
