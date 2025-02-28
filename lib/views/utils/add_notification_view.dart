import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:simup_up/enums/enums.dart';
import 'package:simup_up/views/components/chips_container.dart';
import 'package:simup_up/views/components/custom_toast.dart';
import 'package:simup_up/views/components/primary_button.dart';
import 'package:simup_up/views/components/reminder_app_bar.dart';
import 'package:simup_up/views/components/user_campuses.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/utils/database_manager.dart';
import 'package:simup_up/views/utils/local_notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class AddNotificationView extends StatefulWidget {
  final int editingIndex;
  final Map<String, dynamic> editingItem;
  final Function(String) onReminderUpdate;

  const AddNotificationView(
      {super.key,
      required this.onReminderUpdate,
      this.editingIndex = -1,
      this.editingItem = const {}});

  @override
  State<AddNotificationView> createState() => _AddNotificationViewState();
}

class _AddNotificationViewState extends State<AddNotificationView> {
  int? selectedCampusIndex;
  late int _dayOfWeekIndex;
  late int _timeOfDayIndex;
  late int _notificationId;
  bool savingReminder = false;

  void initialize() {
    bool isEditing = widget.editingIndex >= 0;

    selectedCampusIndex = isEditing ? widget.editingItem["campus"] : null;
    _dayOfWeekIndex = isEditing ? widget.editingItem["day"] : -1;
    _timeOfDayIndex = isEditing ? widget.editingItem["time"] : -1;
    _notificationId = isEditing ? widget.editingItem["reminderId"] : 0;
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  void _showToastOnError() {
    CustomToast.buildToast(
        context,
        const Color(0xFFE40000),
        AppLocalizations.of(context)!.reminderErrorTitle,
        AppLocalizations.of(context)!.reminderErrorText,
        Icons.error_rounded);
  }

  void _createNewReminder() async {
    bool isEditing = widget.editingIndex >= 0;
    setState(() {
      savingReminder = true;
    });

    if (isEditing) {
      _updateReminder();
    } else {
      _saveReminder();
    }
  }

  void _deleteReminder() async {
    DatabaseHelper dbHelper = DatabaseHelper();

    setState(() {
      savingReminder = true;
    });

    try {
      await dbHelper.deleteReminder(widget.editingIndex);
      await _cancelReminder();

      widget.onReminderUpdate('delete');
      print('Reminder deleted');

      Navigator.of(context).pop(true);
    } catch (err) {
      _showToastOnError();
      log("Error while deleting reminder with id=${widget.editingIndex}: ${err}");
    }
  }

  void _saveReminder() async {
    DatabaseHelper dbHelper = DatabaseHelper();

    try {
      await dbHelper.insertReminder({
        'campus': selectedCampusIndex,
        'day': _dayOfWeekIndex,
        'time': _timeOfDayIndex,
        'reminderId': _notificationId,
      });

      await _scheduleReminder();

      widget.onReminderUpdate('add');

      Navigator.of(context).pop();
    } catch (err) {
      _showToastOnError();
      log("Error while saving new reminder: ${err}");
    }
  }

  dynamic _getDayTime() {
    switch (_dayOfWeekIndex) {
      case 0:
        return DateTime.monday;
      case 1:
        return DateTime.tuesday;
      case 2:
        return DateTime.wednesday;
      case 3:
        return DateTime.thursday;
      case 4:
        return DateTime.friday;
      case 5:
        return DateTime.saturday;
    }
  }

  int _getHourTime() {
    switch (_timeOfDayIndex) {
      case 0:
        return 6;
      case 1:
        return 8;
      case 2:
        return 10;
      case 3:
        return 12;
      case 4:
        return 14;
      case 5:
        return 16;
      case 6:
        return 18;
      default:
        return 0;
    }
  }

  int _getOffsetMinutes(Campus campus) {
    switch (campus) {
      case Campus.villaCampus:
        return 0;
      case Campus.creadCampus:
        return 25;
      case Campus.healthCampus:
        return 20;
    }
  }

  String _buildReminderMessage() {
    String campusName = UserCampus.campusNames(context).elementAt(selectedCampusIndex!);
    String reminderSuffix = _timeOfDayIndex < 3 ? "A.M." : "P.M.";
    String reminderTime = "${_getHourTime()}:10 $reminderSuffix";

    if (selectedCampusIndex == 0) {
      return "${AppLocalizations.of(context)!.busMessage1} $campusName, ${AppLocalizations.of(context)!.busMessage2} $reminderTime";
    } else {
      return "${AppLocalizations.of(context)!.busMessage1} $campusName. ${AppLocalizations.of(context)!.busMessage3}";
    }
  }

  Future<void> _cancelReminder() async {
    await LocalNotificationService().cancelNotification(_notificationId);
  }

  Future<void> _scheduleReminder() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
    await LocalNotificationService().init();

    _notificationId = await LocalNotificationService().scheduleNotification(
        title: AppLocalizations.of(context)!.busArrival,
        description: _buildReminderMessage(),
        scheduledHours: _getHourTime(),
        scheduledMinutes: _getOffsetMinutes(UserCampus.campusList.elementAt(selectedCampusIndex!)),
        repeatDays: [_getDayTime()],
    );
  }

  void _updateReminder() async {
    DatabaseHelper dbHelper = DatabaseHelper();

    try {
      await _cancelReminder();
      await _scheduleReminder();
      await dbHelper.updateReminder(widget.editingIndex, {
        'campus': selectedCampusIndex,
        'day': _dayOfWeekIndex,
        'time': _timeOfDayIndex,
        'reminderId': _notificationId,
      });

      widget.onReminderUpdate('update');

      Navigator.of(context).pop();
    } catch (err) {
      _showToastOnError();
      log("Error while update reminder: ${err}");
    }
  }

  bool _isNotificationValid() {
    return (selectedCampusIndex != null &&
        _dayOfWeekIndex >= 0 &&
        _timeOfDayIndex >= 0);
  }

  void handleCampusSelection(BuildContext context, int index) {
    setState(() {
      selectedCampusIndex = index;
    });
  }

  void handleDaySelection(int index) {
    setState(() {
      _dayOfWeekIndex = index;
    });
  }

  void handleTimeSelection(int index) {
    setState(() {
      _timeOfDayIndex = index;
    });
  }

  bool _isSaturday() {
    return _dayOfWeekIndex == 5;
  }

  int _getAvailableSchedule() {
    List<String> availableSchedule = UserCampus.operationTimes;

    if (selectedCampusIndex == 0 && _isSaturday()) {
      availableSchedule = UserCampus.operationTimes.sublist(0, 5);

      if (_timeOfDayIndex >= 5) {
        _timeOfDayIndex = -1;
      }
    } else if ((selectedCampusIndex == 1 || selectedCampusIndex == 2) && _isSaturday()) {
      availableSchedule = [];
      _timeOfDayIndex = -1;
    }

    return availableSchedule.length;
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.editingIndex >= 0;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            ReminderAppBar(
              isEditing: isEditing,
              onDelete: _deleteReminder,
              onBack: () => Navigator.of(context).pop(),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    isEditing
                                        ? AppLocalizations.of(context)!
                                            .editReminder
                                        : AppLocalizations.of(context)!
                                            .addReminder,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                    textAlign: TextAlign.start,
                                    textScaler: const TextScaler.linear(1.0),
                                ),
                                VerticalSpacing(8.0),
                                Text(
                                    AppLocalizations.of(context)!
                                        .selectCampusReminder,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    textAlign: TextAlign.start,
                                    textScaler: const TextScaler.linear(1.0),
                                ),
                                VerticalSpacing(16.0),
                                DropdownButtonFormField<int>(
                                  isDense: true,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 16.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                          width: 0.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                          width: 0.0),
                                    ),
                                    border: const OutlineInputBorder(),
                                  ),
                                  iconEnabledColor: Theme.of(context)
                                      .colorScheme
                                      .onSurface,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  hint: Text(
                                    AppLocalizations.of(context)!
                                        .yourCampusHint,
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary),
                                    textScaler: const TextScaler.linear(1.0),
                                  ),
                                  value: selectedCampusIndex,
                                  onChanged: (int? newValue) {
                                    if (newValue != null) {
                                      handleCampusSelection(context, newValue);
                                    }
                                  },
                                  items: UserCampus.campusNames(context)
                                      .asMap()
                                      .entries
                                      .map<DropdownMenuItem<int>>((entry) {
                                    final index = entry.key;
                                    final value = entry.value;
                                    return DropdownMenuItem<int>(
                                      value: index,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface),
                                        textScaler: const TextScaler.linear(1.0),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                VerticalSpacing(16.0),
                                Text(
                                    AppLocalizations.of(context)!.notifyThisDay,
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                    textAlign: TextAlign.start,
                                    textScaler: const TextScaler.linear(1.0),
                                ),
                                VerticalSpacing(12.0),
                                ChipsContainer(
                                  selectedChip: _dayOfWeekIndex,
                                  chipList: UserCampus.daysOfWeek(context),
                                  onCardSelected: (index) {
                                    handleDaySelection(index);
                                  },
                                ),
                                VerticalSpacing(16.0),
                                Text(
                                    AppLocalizations.of(context)!
                                        .notifyThisHour,
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                    textAlign: TextAlign.start,
                                    textScaler: const TextScaler.linear(1.0),
                                ),
                                VerticalSpacing(12.0),
                                ChipsContainer(
                                  selectedChip: _timeOfDayIndex,
                                  hasRestrictions: true,
                                  chipsEnabled: _getAvailableSchedule(),
                                  chipList: UserCampus.operationTimes,
                                  onCardSelected: (index) {
                                    handleTimeSelection(index);
                                  },
                                ),
                                VerticalSpacing(24.0),
                                PrimaryButton(
                                    buttonText: isEditing
                                        ? AppLocalizations.of(context)!
                                            .updateReminder
                                        : AppLocalizations.of(context)!
                                            .createReminder,
                                    hasPadding: false,
                                    onButtonPressed: () {
                                      _createNewReminder();
                                    },
                                    isButtonEnabled: _isNotificationValid() &&
                                        !savingReminder)
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                VerticalSpacing(16.0)
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
