import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:simup_up/views/utils/station-model.dart';
import 'package:simup_up/views/utils/update-observable.dart';

class CurrentStationCard extends StatefulWidget {
  final bool isRouteOne;
  final VoidCallback onCurrentStationTap;
  final UpdateObservable updateObservable;

  const CurrentStationCard(
      {Key? key,
      required this.onCurrentStationTap,
      required this.updateObservable,
      required this.isRouteOne})
      : super(key: key);

  @override
  State<CurrentStationCard> createState() => _CurrentStationCardState();
}

class _CurrentStationCardState extends State<CurrentStationCard> {
  bool _routeOperational = false;
  int _currentStationIndex = 0;
  String _currentStationName = "";

  @override
  void initState() {
    super.initState();
    _currentStationIndex = widget.isRouteOne ? StationModel.currentRouteOne : StationModel.currentRouteTwo;
    widget.updateObservable
        .subscribe(_handleUpdate); // Subscribe to update notifications
  }

  @override
  void dispose() {
    widget.updateObservable
        .unsubscribe(_handleUpdate); // Unsubscribe from update notifications
    super.dispose();
  }

  String _getIconAsset(BuildContext context) {
    String iconAsset = "";

    if (widget.isRouteOne) {
      iconAsset = Theme.of(context).colorScheme.brightness == Brightness.light
          ? 'assets/images/illustrations/route-one-icon.svg'
          : 'assets/images/illustrations/route-one-icon-dark.svg';
    } else {
      iconAsset = Theme.of(context).colorScheme.brightness == Brightness.light
          ? 'assets/images/illustrations/route-two-icon.svg'
          : 'assets/images/illustrations/route-two-icon-dark.svg';
    }

    return iconAsset;
  }

  String _getRouteMessage(BuildContext context) {
    String routeMessage = "";

    if (widget.isRouteOne) {
      routeMessage = AppLocalizations.of(context)!.routeOneNotOperational;
    } else {
      routeMessage = AppLocalizations.of(context)!.routeTwoNotOperational;
    }

    return routeMessage;
  }

  void _handleUpdate() {
    try {
      _currentStationIndex = widget.isRouteOne ? StationModel.currentRouteOne : StationModel.currentRouteTwo;
      _currentStationName = StationModel.getStationsForDirection(widget.isRouteOne)
          .elementAt(_currentStationIndex)["stationName"];
      _routeOperational = true;
    } catch (e) {
      _routeOperational = false;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    StationModel.getStationIntervals(context);
    _handleUpdate();
    double screenWidth = MediaQuery.of(context).size.width;
    String stationIconAsset = _getIconAsset(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Row(
          children: [
            _routeOperational
                ? SvgPicture.asset(
                    stationIconAsset,
                    height: 72.0,
                  )
                : Icon(
                    Icons.departure_board_rounded,
                    size: 48.0,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            HorizontalSpacing(24.0),
            SizedBox(
              width: screenWidth * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _routeOperational ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.approximatedStation,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      VerticalSpacing(4.0),
                      Text(
                        _currentStationName,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      VerticalSpacing(12.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          Theme.of(context).colorScheme.onBackground,
                          disabledBackgroundColor:
                          Theme.of(context).colorScheme.surface,
                          disabledForegroundColor:
                          Theme.of(context).colorScheme.onTertiaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 16.0),
                        ),
                        onPressed: widget.onCurrentStationTap,
                        child: Text(
                          AppLocalizations.of(context)!.seeMore,
                          textHeightBehavior: const TextHeightBehavior(
                            applyHeightToLastDescent: true,
                            applyHeightToFirstAscent: false,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                    ],
                  ) : Text(
                    _getRouteMessage(context),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      height: 1.2,
                      color: Theme.of(context).colorScheme.onBackground
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
