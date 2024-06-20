import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/components/route_tabs.dart';
import 'package:simup_up/views/styles/spaces.dart';

class RoutesView extends StatefulWidget {
  const RoutesView({super.key});

  @override
  State<RoutesView> createState() => _RoutesViewState();
}

class _RoutesViewState extends State<RoutesView> {
  @override
  void initState() {
    super.initState();
  }

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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                AppLocalizations.of(context)!.busTracking,
                                style: Theme.of(context).textTheme.displayMedium,
                                textAlign: TextAlign.start),
                            HorizontalSpacing(8.0),
                            Tooltip(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              triggerMode: TooltipTriggerMode.tap,
                              textStyle: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14.0,
                                color: Theme.of(context).colorScheme.surface
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 24.0),
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              message: AppLocalizations.of(context)!.predictionModelDisclaimer,
                              child: Icon(
                                Icons.help_rounded,
                                color: Theme.of(context).colorScheme.onSurface,
                                size: 24.0,
                              ),
                            )
                          ],
                        ),
                        VerticalSpacing(8.0),
                        Text(AppLocalizations.of(context)!.busTrackingDescription,
                            style: Theme.of(context).textTheme.bodySmall,
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
