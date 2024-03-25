import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/styles/spaces.dart';

class StationCard extends StatelessWidget {
  final String name;
  final String arrivalInfo;
  final bool isCurrentStation;
  final VoidCallback onTap;
  const StationCard({super.key, required this.name, required this.arrivalInfo, required this.onTap, required this.isCurrentStation});

  @override
  Widget build(BuildContext context) {
    String enabledStationLineAsset = Theme.of(context).colorScheme.brightness == Brightness.light ? 'assets/images/illustrations/station-line-enabled.svg' : 'assets/images/illustrations/station-line-enabled-dark.svg';
    String disabledStationLineAsset = Theme.of(context).colorScheme.brightness == Brightness.light ? 'assets/images/illustrations/station-line-disabled.svg' : 'assets/images/illustrations/station-line-disabled-dark.svg';
    double screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: screenWidth,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isCurrentStation ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.background,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                    isCurrentStation ? enabledStationLineAsset : disabledStationLineAsset,
                    fit: BoxFit.fill,
                ),
                HorizontalSpacing(0.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.headlineMedium
                    ),
                    VerticalSpacing(4.0),
                    Text(
                      isCurrentStation
                          ? AppLocalizations.of(context)!.currentStation + arrivalInfo
                          : AppLocalizations.of(context)!.arrivalTime + arrivalInfo,
                      style: TextStyle(
                          fontFamily: 'Inter',
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 12.0,
                          fontWeight: FontWeight.normal
                      ),
                    ),
                    VerticalSpacing(4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Más información",
                          style: TextStyle(
                              fontFamily: 'Inter',
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20.0,
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
