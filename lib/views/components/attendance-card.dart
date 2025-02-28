import 'package:flutter/material.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AttendanceCard extends StatefulWidget {
  final String date;
  final String route;

  const AttendanceCard({
    Key? key,
    required this.date, required this.route,
  }) : super(key: key);

  @override
  State<AttendanceCard> createState() => _AttendanceCardState();
}

class _AttendanceCardState extends State<AttendanceCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(24.0),
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(24.0),
        onTap: (){},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.date}:",
                                  style: Theme.of(context).textTheme.headlineMedium,
                                  textScaler: const TextScaler.linear(1.0),
                                ),
                                HorizontalSpacing(4.0),
                                Text(
                                  widget.date,
                                  style: Theme.of(context).textTheme.labelSmall,
                                  textScaler: const TextScaler.linear(1.0),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.route}:",
                                  style: Theme.of(context).textTheme.headlineMedium,
                                  textScaler: const TextScaler.linear(1.0),
                                ),
                                HorizontalSpacing(4.0),
                                Text(
                                  widget.route,
                                  style: Theme.of(context).textTheme.labelSmall,
                                  textScaler: const TextScaler.linear(1.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
