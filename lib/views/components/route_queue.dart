import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:simup_up/views/components/station_card.dart';
import 'package:simup_up/views/route_details_view.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:simup_up/views/utils/custom-page-router.dart';

class RouteQueue extends StatefulWidget {
  final List<Map<String, dynamic>> routeList;

  const RouteQueue({super.key, required this.routeList});

  @override
  State<RouteQueue> createState() => _RouteQueueState();
}

class _RouteQueueState extends State<RouteQueue> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController = ScrollOffsetController();
  int _currentStationIndex = 5;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => itemScrollController.jumpTo(
      index: 4,
    ));
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
                    itemScrollController: itemScrollController,
                    itemCount: routes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Opacity(
                        opacity: (index == _currentStationIndex) ? 1.0 : 0.8,
                        child: StationCard(
                          name: routes.elementAt(index)["stationName"],
                          arrivalInfo: routes.elementAt(index)["arrivalTime"],
                          isCurrentStation: index == _currentStationIndex,
                          onTap: () {
                            Navigator.of(context).push(CustomPageRoute(RouteDetailsView(stationIndex: index)));
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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                    0.2,
                    1.0
                  ],
                  colors: [
                    Color(0xFFFAF9F6),
                    Color(0x00FAF9F6)
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
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [
                      0.2,
                      1.0
                    ],
                    colors: [
                      Color(0xFFFAF9F6),
                      Color(0x00FAF9F6)
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