import 'package:flutter/material.dart';
import 'package:simup_up/enums/enums.dart';
import 'package:simup_up/views/components/info_tip.dart';
import 'package:simup_up/views/components/user_stations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/components/user_zones.dart';
import 'package:simup_up/views/styles/spaces.dart';

class RouteDetailsView extends StatelessWidget {
  final int stationIndex;

  const RouteDetailsView({super.key, required this.stationIndex});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    List<String> _getStationRoutes(List<Zone> zones) {
      List<String> zoneNames = UserZones.zoneNames(context);

      List<String> routes = zones.map((zone) {
        return zoneNames.elementAt(UserZones.zoneList.indexOf(zone));
      }).toList();

      return routes;
    }

    String _getStationString(List<String> zoneList) {
      if (zoneList.isEmpty) return "";
      String zoneNames = zoneList.join(", ");
      zoneNames = zoneNames.replaceRange(zoneNames.lastIndexOf(", "), zoneNames.length, ".");
      return zoneNames;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              centerTitle: true,
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: Text(UserStations.stationNames(context)
                  .elementAt(stationIndex),
                style: Theme.of(context).textTheme.labelSmall,
                textScaler: const TextScaler.linear(1.0),
              ),
              scrolledUnderElevation: 0.2,
              leading: IconButton(
                enableFeedback: false,
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    DecoratedBox(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16.0),
                              bottomRight: Radius.circular(16.0))),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32.0), bottomRight: Radius.circular(32.0)),
                        child: Image.asset(
                          UserStations.stationAsset.elementAt(stationIndex),
                          width: screenWidth,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 32.0, horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            UserStations.stationNames(context)
                                .elementAt(stationIndex),
                            style:  Theme.of(context).textTheme.displayLarge,
                            textScaler: const TextScaler.linear(1.0),
                          ),
                          VerticalSpacing(8.0),
                          Text(
                            UserStations.stationInfo(context)
                                .elementAt(stationIndex),
                            style: Theme.of(context).textTheme.displaySmall,
                            textScaler: const TextScaler.linear(1.0),
                          ),
                          VerticalSpacing(16.0),
                          Text(
                            AppLocalizations.of(context)!.helpfulInfo,
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary
                            ),
                            textScaler: const TextScaler.linear(1.0),
                          ),
                          VerticalSpacing(16.0),
                          InfoTip(
                            tipTitle: AppLocalizations.of(context)!.routeAccess,
                            tipDescription: _getStationString(_getStationRoutes(UserStations.stationRoutes.elementAt(stationIndex))),
                            tipIcon: Icons.directions_bus_rounded,
                          ),
                          VerticalSpacing(16.0),
                          InfoTip(
                            tipTitle: "Alta densidad de transporte luego de las 4 P.M.",
                            tipDescription: "",
                            tipIcon: Icons.bus_alert_rounded,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                VerticalSpacing(16.0)
                ]),
              ),
            ],
        ),
      ),
    );
  }
}
