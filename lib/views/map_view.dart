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
    String mapAsset =
        Theme.of(context).colorScheme.brightness == Brightness.light
            ? 'assets/images/illustrations/simup-map-system.svg'
            : 'assets/images/illustrations/simup-map-system-dark.svg';
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
                    Text(AppLocalizations.of(context)!.mapGeneralView,
                        style: Theme.of(context).textTheme.displayMedium,
                        textAlign: TextAlign.start),
                    VerticalSpacing(8.0),
                    Text(
                        AppLocalizations.of(context)!.mapGeneralViewDescription,
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.start),
                  ],
                ),
              ),
            ),
          ),
          VerticalSpacing(24.0),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 4,
                child: SvgPicture.asset(mapAsset,
                    width: screenWidth,
                    fit: BoxFit.fitWidth
                ),
              ),
            ),
          ),
          VerticalSpacing(24.0)
        ],
      ),
    ));
  }
}
