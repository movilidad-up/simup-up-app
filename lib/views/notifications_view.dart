import 'package:flutter/material.dart';
import 'package:simup_up/views/components/custom_toast.dart';
import 'package:simup_up/views/components/label_button.dart';
import 'package:simup_up/views/components/reminder_card.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/utils/add_notification_view.dart';
import 'package:simup_up/views/utils/custom-page-router.dart';
import 'package:simup_up/views/utils/database_manager.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'components/empty-notifications.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  List<Map<String, dynamic>> reminders = [];
  bool loadingReminders = true;
  bool canAddReminders = true;

  @override
  void initState() {
    super.initState();
    _initialize();
    _checkReminderLimit();
  }

  // Run when reminders has been updated.

  Future<void> _checkReminderLimit() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    canAddReminders = await dbHelper.canAddReminder();
  }

  Future<void> _loadReminders() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    try {
      reminders = await dbHelper.getReminders();
    } catch (error) {
      // Handle error
      print("Error loading reminders: $error");
    } finally {
      if (mounted) {
        setState(() {
          loadingReminders = false;
        });
      }
    }
  }

  void _showToastOnDisable() {
    if (!canAddReminders) {
      CustomToast.buildToast(
          context,
          const Color(0xFFF18805),
          AppLocalizations.of(context)!.reminderTooManyTitle,
          AppLocalizations.of(context)!.reminderTooManyText,
          Icons.warning_rounded);
    }
  }

  void _showUpdateToast(String updateType) {
    Color toastColor = const Color(0xFF44B300);
    String message = '';

    if (updateType == 'add') {
      message = AppLocalizations.of(context)!.reminderAdded;
    } else if (updateType == 'delete') {
      message = AppLocalizations.of(context)!.reminderDeleted;
    } else {
      message = AppLocalizations.of(context)!.reminderUpdated;
    }

    CustomToast.buildToast(
        context,
        const Color(0xFF09BC8A),
        AppLocalizations.of(context)!.success,
        message,
        Icons.check_circle_rounded);
  }

  void _initialize() async {
    await _loadReminders();
  }

  void onReminderUpdate(String updateType) {
    _checkReminderLimit();
    _loadReminders();
    _showUpdateToast(updateType);
  }

  Widget renderReminders() {
    return loadingReminders ? Skeletonizer(
      enabled: loadingReminders,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(top: 0, right: 24.0, bottom: 8.0, left: 24.0),
            color: Theme.of(context).colorScheme.surfaceContainer,
            child: ListTile(
              title: Container(
                height: 16.0,
                color: Colors.grey[300],
              ),
              subtitle: Container(
                height: 14.0,
                color: Colors.grey[200],
              ),
            ),
          );
        },
      ),
    ) : generateList(reminders);
  }

  Widget generateList(
      List<Map<String, dynamic>> reminders) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      // Use default ScrollPhysics or specify any other appropriate physics
      itemCount: reminders.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 8.0),
          child: ReminderCard(
            campusIndex: reminders[index]["campus"],
            dayOfWeekIndex: reminders[index]["day"],
            operationTimeIndex: reminders[index]["time"],
            reminderIndex: reminders[index]["id"],
            reminderItem: reminders[index],
            onReminderUpdated: onReminderUpdate,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 32.0, bottom: 24.0, left: 24.0, right: 24.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.notifications,
                      style: Theme.of(context).textTheme.displayMedium,
                      textScaler: const TextScaler.linear(1.0),
                    ),
                    VerticalSpacing(8.0),
                    Text(
                      AppLocalizations.of(context)!.notificationsDescription,
                      style: Theme.of(context).textTheme.bodySmall,
                      textScaler: const TextScaler.linear(1.0),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.activeReminders,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        textScaler: const TextScaler.linear(1.0),
                      ),
                      GestureDetector(
                        onTap: _showToastOnDisable,
                        child: LabelButton(
                          buttonIcon: Icons.add,
                          buttonText: AppLocalizations.of(context)!.addReminder,
                          hasPadding: false,
                          onButtonPressed: () {
                            Navigator.of(context)
                                .push(CustomPageRoute(AddNotificationView(
                              onReminderUpdate: onReminderUpdate,
                            )));
                          },
                          isButtonEnabled: canAddReminders,
                        ),
                      ),
                    ],
                  ),
                  VerticalSpacing(16.0),
                ],
              ),
            ),
            reminders.isEmpty
                ? const EmptyNotifications()
                : AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: renderReminders(),
            ),
          ],
        ),
      ),
    );
  }
}