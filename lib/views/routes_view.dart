import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/components/current_station_card.dart';
import 'package:simup_up/views/components/route_tabs.dart';
import 'package:simup_up/views/styles/spaces.dart';

class RoutesView extends StatefulWidget {
  const RoutesView({super.key});

  @override
  State<RoutesView> createState() => _RoutesViewState();
}

class _RoutesViewState extends State<RoutesView> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
        child: SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 32.0, bottom: 0.0, left: 24.0, right: 24.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: screenWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  AppLocalizations.of(context)!.busTracking,
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                  textAlign: TextAlign.start),
                              HorizontalSpacing(8.0),
                              Icon(
                                Icons.help_rounded,
                                color: Colors.black,
                                size: 24.0,
                              )
                            ],
                          ),
                        ),
                        Text(AppLocalizations.of(context)!.busTrackingDescription,
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.black54),
                            textAlign: TextAlign.start),
                      ],
                    ),
                  ),
                ),
              ),
              VerticalSpacing(24.0),
              Expanded(
                  child: RouteTabs()
              ),
            ],
          ),
        ));
  }
}
