import 'package:flutter/material.dart';
import 'package:simup_up/views/components/empty-notifications.dart';
import 'package:simup_up/views/components/primary_button.dart';
import 'package:simup_up/views/components/reminder_card.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/utils/add_notification_view.dart';
import 'package:simup_up/views/utils/custom-page-router.dart';
import 'package:simup_up/views/utils/database_manager.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  List<Map<String, dynamic>> reminders = [];
  bool _remindersLoaded = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _loadReminders() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    reminders = await dbHelper.getReminders();
    setState(() {
      _remindersLoaded = true;
    });
  }

  void _initialize() async {
    await _loadReminders();
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
                    Text(AppLocalizations.of(context)!.notifications,
                        style: Theme.of(context).textTheme.displayMedium,
                        textAlign: TextAlign.start),
                    VerticalSpacing(8.0),
                    Text(AppLocalizations.of(context)!.notificationsDescription,
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.start),
                  ],
                ),
              ),
            ),
          ),
          VerticalSpacing(24.0),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.activeReminders,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                    VerticalSpacing(16.0),
                    SizedBox(
                      width: screenWidth,
                      height: screenHeight * 0.5,
                      child: reminders.isEmpty
                          ? const EmptyNotifications()
                          : ListView.builder(
                              itemCount: reminders.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ReminderCard(
                                    campusIndex:
                                        reminders.elementAt(index)["campus"],
                                    dayOfWeekIndex:
                                        reminders.elementAt(index)["day"],
                                    operationTimeIndex:
                                        reminders.elementAt(index)["time"],
                                    reminderIndex: reminders.elementAt(index)["id"],
                                    reminderItem: reminders.elementAt(index),
                                    onReminderUpdated: _loadReminders,
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
                PrimaryButton(
                    buttonText: AppLocalizations.of(context)!.addReminder,
                    hasPadding: false,
                    onButtonPressed: () {
                      Navigator.of(context)
                          .push(CustomPageRoute(AddNotificationView(
                        onReminderAdded: () {
                          _loadReminders();
                        },
                      )));
                    },
                    isButtonEnabled: true)
              ],
            ),
          )),
          VerticalSpacing(24.0)
        ],
      ),
    ));
  }
}
