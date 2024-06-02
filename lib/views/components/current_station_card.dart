import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:marquee/marquee.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:simup_up/views/utils/route_data_handler.dart';
import 'package:simup_up/views/utils/route_status_checker.dart';
import 'package:simup_up/views/utils/route_stop_checker.dart';
import 'package:simup_up/views/utils/station-model.dart';
import 'package:simup_up/views/utils/update-observable.dart';

class CurrentStationCard extends StatefulWidget {
  final bool isRouteOne;
  final VoidCallback onCurrentStationTap;
  final UpdateObservable updateObservable;

  const CurrentStationCard({
    Key? key,
    required this.onCurrentStationTap,
    required this.updateObservable,
    required this.isRouteOne,
  }) : super(key: key);

  @override
  State<CurrentStationCard> createState() => _CurrentStationCardState();
}

class _CurrentStationCardState extends State<CurrentStationCard> {
  bool _routeOperational = false;
  String _currentStationName = "";

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      StationModel.getStationIntervals(context);
    });
    widget.updateObservable.subscribe(_handleUpdate);
  }

  @override
  void dispose() {
    widget.updateObservable.unsubscribe(_handleUpdate);
    super.dispose();
  }

  String _getIconAsset(BuildContext context) {
    final brightness = Theme.of(context).colorScheme.brightness;
    return 'assets/images/illustrations/route-${widget.isRouteOne ? 'one' : 'two'}-icon${brightness == Brightness.light ? '' : '-dark'}.svg';
  }

  bool _shouldUseMarquee(String text, double maxWidth) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: Theme.of(context).textTheme.bodyMedium),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    return textPainter.didExceedMaxLines;
  }

  String _getRouteMessage(BuildContext context) {
    return widget.isRouteOne ? AppLocalizations.of(context)!.routeOneNotOperational : AppLocalizations.of(context)!.routeTwoNotOperational;
  }

  bool _checkIfOnStop() {
    return RouteStopChecker.isBusOnStop(widget.isRouteOne);
  }

  void _handleUpdate() {
    bool isRouteWorking = widget.isRouteOne ? RouteStatusChecker.getRouteOneStatus() : RouteStatusChecker.getRouteTwoStatus();

    if (isRouteWorking) {
      StationModel.getStationIntervals(context);
      _currentStationName = RouteDataHandler.getCurrentStationName(widget.isRouteOne, context);
    }

    _routeOperational = isRouteWorking;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    StationModel.getStationIntervals(context);
    _handleUpdate();
    final screenWidth = MediaQuery.of(context).size.width;
    final stationIconAsset = _getIconAsset(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
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
                  if (_routeOperational) ...[
                    _checkIfOnStop() ? Text(
                      "${AppLocalizations.of(context)!.onStop} | ${widget.isRouteOne ? AppLocalizations.of(context)!.routeOne : AppLocalizations.of(context)!.routeTwo}",
                      style: Theme.of(context).textTheme.labelLarge,
                    ) : _shouldUseMarquee("${AppLocalizations.of(context)!.approximatedStation} | ${widget.isRouteOne ? AppLocalizations.of(context)!.routeOne : AppLocalizations.of(context)!.routeTwo}", screenWidth * 0.5) ? SizedBox(
                      height: 20.0,
                      width: screenWidth * 0.5,
                      child: Marquee(
                        text: "${AppLocalizations.of(context)!.approximatedStation} | ${widget.isRouteOne ? AppLocalizations.of(context)!.routeOne : AppLocalizations.of(context)!.routeTwo}",
                        style: Theme.of(context).textTheme.labelLarge,
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
                    ) : Text(
                      "${AppLocalizations.of(context)!.approximatedStation} | ${widget.isRouteOne ? AppLocalizations.of(context)!.routeOne : AppLocalizations.of(context)!.routeTwo}",
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
                        Theme.of(context).colorScheme.onSurface,
                        disabledBackgroundColor:
                        Theme.of(context).colorScheme.surfaceContainer,
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
                  ] else ...[
                    Text(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
