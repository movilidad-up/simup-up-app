import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmptyNotifications extends StatelessWidget {
  const EmptyNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return DecoratedBox(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: screenWidth * 0.72,
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.emptyReminders,
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
                    AppLocalizations.of(context)!.emptyRemindersDescription,
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
                ? "assets/images/illustrations/empty-reminders.svg"
                : "assets/images/illustrations/empty-reminders-dark.svg"),
          ],
        ),
      ),
    );
  }
}
