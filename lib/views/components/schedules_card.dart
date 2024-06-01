import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/styles/spaces.dart';

class SchedulesCard extends StatefulWidget {
  final VoidCallback onSchedulesTap;

  const SchedulesCard({
    Key? key,
    required this.onSchedulesTap,
  }) : super(key: key);

  @override
  State<SchedulesCard> createState() => _SchedulesCardState();
}

class _SchedulesCardState extends State<SchedulesCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(24.0),
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        borderRadius: BorderRadius.circular(24.0),
        onTap: widget.onSchedulesTap,
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.schedules,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          Text(
                            AppLocalizations.of(context)!.goToSchedules,
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ],
                      ),
                      VerticalSpacing(12.0),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                        size: 24.0,
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
