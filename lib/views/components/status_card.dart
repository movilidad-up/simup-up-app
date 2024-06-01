import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/enums/enums.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:simup_up/views/utils/route_status_checker.dart';
import 'package:simup_up/views/utils/weather_checker.dart';

class StatusCard extends StatefulWidget {
  const StatusCard({
    Key? key,
  }) : super(key: key);

  @override
  State<StatusCard> createState() => _StatusCardState();
}

class _StatusCardState extends State<StatusCard> {
  late Status routeStatus = Status.operational;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  void _checkStatus() async {
    WeatherChecker weatherChecker = WeatherChecker();

    if (_isRouteOperational()) {
      if (await weatherChecker.shouldRun()) {
        bool isRainyWeather = await weatherChecker.isRainy();
        routeStatus = isRainyWeather ? Status.rainy : Status.operational;
      } else {
        routeStatus = Status.operational;
      }
    } else {
      routeStatus = Status.nonOperational;
    }
  }

  bool _isRouteOperational() {
    return RouteStatusChecker.shouldGenerateRoute();
  }

  Map<String, dynamic> _getStatusInfo() {
    Map<String, dynamic> statusInfo = {};
    IconData icon = Icons.bus_alert_rounded;
    String label = AppLocalizations.of(context)!.operationalLabel;
    String title = AppLocalizations.of(context)!.operationalTitle;

    if (routeStatus == Status.rainy) {
      icon = Icons.cloud_rounded;
      label = AppLocalizations.of(context)!.rainyLabel;
      title = AppLocalizations.of(context)!.rainyTitle;
    } else if (routeStatus == Status.nonOperational) {
      icon = Icons.mode_night_rounded;
      label = AppLocalizations.of(context)!.nonOperationalLabel;
      title = AppLocalizations.of(context)!.nonOperationalTitle;
    }

    statusInfo.addAll({"icon": icon, "label": label, "title": title});

    return statusInfo;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> statusInfo = _getStatusInfo();

    return Material(
      borderRadius: BorderRadius.circular(24.0),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      statusInfo["icon"],
                      color: Theme.of(context).colorScheme.primary,
                      size: 34.0,
                    ),
                    HorizontalSpacing(16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          statusInfo["label"],
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontSize: 16.0,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        Text(
                          statusInfo["title"],
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 20.0,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    ),
                    VerticalSpacing(12.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
