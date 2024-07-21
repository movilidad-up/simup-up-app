import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmptyRoutes extends StatelessWidget {
  final bool isItRouteOne;
  const EmptyRoutes({super.key, required this.isItRouteOne});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: screenWidth * 0.72,
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.emptyRoutes,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface,
                ),
                textScaler: const TextScaler.linear(1.0),
              ),
              VerticalSpacing(4.0),
              Text(
                  isItRouteOne ? AppLocalizations.of(context)!.routeOneOperationsTime : AppLocalizations.of(context)!.routeTwoOperationsTime,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                  textScaler: const TextScaler.linear(1.0),
              ),
            ],
          ),
        ),
        VerticalSpacing(16.0),
        SvgPicture.asset(Theme.of(context)
            .colorScheme
            .brightness ==
            Brightness.light
            ? "assets/images/illustrations/empty-routes.svg"
            : "assets/images/illustrations/empty-routes-dark.svg"),
      ],
    );
  }
}
