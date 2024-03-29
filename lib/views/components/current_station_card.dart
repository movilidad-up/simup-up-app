import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simup_up/views/styles/spaces.dart';

class CurrentStationCard extends StatefulWidget {
  final VoidCallback onCurrentStationTap;

  const CurrentStationCard({super.key, required this.onCurrentStationTap});

  @override
  State<CurrentStationCard> createState() => _CurrentStationCardState();
}

class _CurrentStationCardState extends State<CurrentStationCard> {
  @override
  Widget build(BuildContext context) {
    String stationIconAsset = Theme.of(context).colorScheme.brightness == Brightness.light ? 'assets/images/illustrations/station-icon.svg' : 'assets/images/illustrations/station-icon-dark.svg';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24.0)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Row(
          children: [
            SvgPicture.asset(
              stationIconAsset,
              height: 72.0,
            ),
            HorizontalSpacing(24.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Estación aproximada',
                  style: Theme.of(context).textTheme.labelLarge
                ),
                VerticalSpacing(4.0),
                Text(
                    'Fuente Luminosa',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                VerticalSpacing(12.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onBackground,
                    disabledBackgroundColor: Theme.of(context).colorScheme.surface,
                    disabledForegroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                  ),
                  onPressed: widget.onCurrentStationTap,
                  child: Text(
                    'Ver más',
                    textHeightBehavior: const TextHeightBehavior(
                        applyHeightToLastDescent: true,
                        applyHeightToFirstAscent: false,
                        leadingDistribution: TextLeadingDistribution.even),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
