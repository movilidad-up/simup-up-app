import 'package:flutter/material.dart';
import 'package:simup_up/views/components/user_campuses.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/utils/add_notification_view.dart';
import 'package:simup_up/views/utils/custom-page-router.dart';

class ReminderCard extends StatelessWidget {
  final int campusIndex;
  final int operationTimeIndex;
  final int dayOfWeekIndex;
  final int reminderIndex;
  final Map<String, dynamic> reminderItem;
  final Function(String) onReminderUpdated;

  const ReminderCard({super.key, required this.onReminderUpdated, required this.operationTimeIndex, required this.dayOfWeekIndex, required this.campusIndex, required this.reminderIndex, required this.reminderItem});

  double getScreenFactor(double screenWidth) {
    if (screenWidth < 400.0) {
      return 0.4;
    } else {
      return 0.5;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24.0)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Icon(
                      Icons.bus_alert_rounded,
                      size: 32.0,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                HorizontalSpacing(16.0),
                SizedBox(
                  width: screenWidth * getScreenFactor(screenWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.notifyWhenCampus,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                          color: Theme.of(context).colorScheme.tertiary
                        ),
                      ),
                      VerticalSpacing(2.0),
                      Text(
                          UserCampus.campusNames(context).elementAt(campusIndex),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                            color: Theme.of(context).colorScheme.onSurface
                        ),
                      ),
                      VerticalSpacing(2.0),
                      Text(
                          '${AppLocalizations.of(context)!.theseDays} ${UserCampus.daysOfWeek(context)[dayOfWeekIndex]} ${AppLocalizations.of(context)!.at} ${UserCampus.operationTimes[operationTimeIndex]}.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                            color: Theme.of(context).colorScheme.tertiary
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: (){
                    Navigator.of(context).push(CustomPageRoute(AddNotificationView(
                      onReminderUpdate: onReminderUpdated,
                      editingIndex: reminderIndex,
                      editingItem: reminderItem,
                    )));
                  },
                  icon: Icon(
                    Icons.edit_rounded,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 24.0,
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}
