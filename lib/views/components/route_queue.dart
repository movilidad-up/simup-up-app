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
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  late int _currentStationIndex;
  double _scrollOffsetTop = 0.0;
  double _scrollOffsetBottom = 0.0;

  @override
  void initState() {
    super.initState();
    _currentStationIndex = widget.isRouteOne ? StationModel.currentRouteOne : StationModel.currentRouteTwo;
    WidgetsBinding.instance.addPostFrameCallback((_) => itemScrollController.jumpTo(
      index: _currentStationIndex,
    ));
    itemPositionsListener.itemPositions.addListener(_updateScrollOffset);
  }

  @override
  void dispose() {
    itemPositionsListener.itemPositions.removeListener(_updateScrollOffset);
    super.dispose();
  }

  void _updateScrollOffset() {
    final positions = itemPositionsListener.itemPositions.value;
    if (positions.isNotEmpty) {
      final minIndex = positions.map((position) => position.index).reduce((a, b) => a < b ? a : b);
      final maxIndex = positions.map((position) => position.index).reduce((a, b) => a > b ? a : b);
      final itemCount = widget.routeList.length;

      setState(() {
        _scrollOffsetTop = minIndex == 0 ? 0.0 : 1.0;
        _scrollOffsetBottom = maxIndex == itemCount - 1 ? 0.0 : 1.0;
      });
    }
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
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _scrollOffsetTop,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).colorScheme.surface.withOpacity(1.0),
                    Theme.of(context).colorScheme.surface.withOpacity(0.0),
                  ],
                ),
              ),
              child: SizedBox(
                width: screenWidth,
                height: 80.0,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _scrollOffsetBottom,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Theme.of(context).colorScheme.surface.withOpacity(1.0),
                    Theme.of(context).colorScheme.surface.withOpacity(0.0),
                  ],
                ),
              ),
              child: SizedBox(
                width: screenWidth,
                height: 80.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
