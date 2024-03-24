import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:zoom_widget/zoom_widget.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
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
                          Text(AppLocalizations.of(context)!.mapGeneralView,
                              style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0B1215)),
                              textAlign: TextAlign.start),
                        ],
                      ),
                    ),
                    Text(
                        AppLocalizations.of(context)!.mapGeneralViewDescription,
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
            child: Zoom(
              backgroundColor: const Color(0xFFECEEF6),
              canvasColor: const Color(0xFFECEEF6),
              enableScroll: true,
              initTotalZoomOut: true,
              doubleTapZoom: true,
              child: Center(
                  child: SvgPicture.asset(
                'assets/images/illustrations/simup-map-system.svg',
                fit: BoxFit.fitHeight,
              )),
            ),
          ),
          VerticalSpacing(24.0)
        ],
      ),
    ));
  }
}
