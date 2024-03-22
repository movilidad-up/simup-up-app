import 'package:flutter/material.dart';
import 'package:simup_up/views/components/station_card.dart';
import 'package:simup_up/views/styles/spaces.dart';

class RouteQueue extends StatefulWidget {
  final List<Map<String, dynamic>> routeList;

  const RouteQueue({super.key, required this.routeList});

  @override
  State<RouteQueue> createState() => _RouteQueueState();
}

class _RouteQueueState extends State<RouteQueue> {
  int _currentStationIndex = 0;

  @override
  void initState() {
    super.initState();
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
              key: const Key('tasksContainer'),
              duration: const Duration(milliseconds: 300),
              child: Expanded(
                child: ListView.builder(
                    itemCount: routes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Opacity(
                        opacity: (index == _currentStationIndex) ? 1.0 : 0.8,
                        child: StationCard(
                          name: routes.elementAt(index)["stationName"],
                          arrivalInfo: routes.elementAt(index)["stationArrivalInfo"],
                          isCurrentStation: index == _currentStationIndex,
                          onTap: () {
                            print("Clicked this station.");
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