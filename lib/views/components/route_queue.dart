import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:simup_up/views/components/station_card.dart';
import 'package:simup_up/views/route_details_view.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:simup_up/views/utils/custom-page-router.dart';
import 'package:simup_up/views/utils/station-model.dart';

class RouteQueue extends StatefulWidget {
  final List<Map<String, dynamic>> routeList;
  final bool isRouteOne;

  const RouteQueue({super.key, required this.routeList, required this.isRouteOne});

  @override
  State<RouteQueue> createState() => _RouteQueueState();
}

class _RouteQueueState extends State<RouteQueue> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController = ScrollOffsetController();
  final ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  late int _currentStationIndex;

  @override
  void initState() {
    super.initState();
    _currentStationIndex = widget.isRouteOne ? StationModel.currentRouteOne : StationModel.currentRouteTwo;
    WidgetsBinding.instance.addPostFrameCallback((_) => itemScrollController.jumpTo(
      index: _currentStationIndex,
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> routes = widget.routeList;
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Column(
          children: [
            VerticalSpacing(16.0),
            AnimatedContainer(
              key: const Key('routesContainer'),
              duration: const Duration(milliseconds: 300),
              child: Expanded(
                child: ScrollablePositionedList.builder(
                    scrollOffsetController: scrollOffsetController,
                    scrollOffsetListener: scrollOffsetListener,
                    itemScrollController: itemScrollController,
                    itemPositionsListener: itemPositionsListener,
                    itemCount: routes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Opacity(
                        opacity: (routes.elementAt(index)["stationIndex"] == _currentStationIndex) ? 1.0 : 0.8,
                        child: StationCard(
                          name: routes.elementAt(index)["stationName"],
                          arrivalInfo: routes.elementAt(index)["arrivalTime"],
                          isCurrentStation: routes.elementAt(index)["stationIndex"] == _currentStationIndex,
                          onTap: () {
                            Navigator.of(context).push(
                                CustomPageRoute(
                                    RouteDetailsView(stationIndex: routes.elementAt(index)["stationIndex"]),
                                )
                            );
                          },
                        ),
                      );
                  }),
              ),
            ),
          ],
        ),
        Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [
                    0.2,
                    1.0
                  ],
                  colors: [
                    Theme.of(context).colorScheme.background,
                    Theme.of(context).colorScheme.inverseSurface
                  ],
                )
              ),
              child: SizedBox(
                width: screenWidth,
                height: 80.0,
              ),
            )
        ),
        Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: const [
                      0.2,
                      1.0
                    ],
                    colors: [
                      Theme.of(context).colorScheme.background,
                      Theme.of(context).colorScheme.inverseSurface
                    ],
                  )
              ),
              child: SizedBox(
                width: screenWidth,
                height: 80.0,
              ),
            )
        ),
      ],
    );
  }
}