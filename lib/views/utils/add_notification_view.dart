import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:simup_up/views/components/chips_container.dart';
import 'package:simup_up/views/components/primary_button.dart';
import 'package:simup_up/views/components/user_campuses.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/utils/database_manager.dart';

class AddNotificationView extends StatefulWidget {
  final int editingIndex;
  final Map<String, dynamic> editingItem;
  final Function() onReminderAdded;

  const AddNotificationView(
      {super.key,
      required this.onReminderAdded,
      this.editingIndex = -1,
      this.editingItem = const {}});

  @override
  State<AddNotificationView> createState() => _AddNotificationViewState();
}

class _AddNotificationViewState extends State<AddNotificationView> {
  int? selectedCampusIndex;
  late int _dayOfWeekIndex;
  late int _timeOfDayIndex;
  bool savingReminder = false;

  void initialize() {
    bool isEditing = widget.editingIndex >= 0;

    selectedCampusIndex = isEditing ? widget.editingItem["campus"] : null;
    _dayOfWeekIndex = isEditing ? widget.editingItem["day"] : -1;
    _timeOfDayIndex = isEditing ? widget.editingItem["time"] : -1;
  }

  @override
  void initState() {
    initialize();
    super.initState();
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

      widget.onReminderAdded();

      Navigator.of(context).pop();
    } catch (err) {
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
      });

      widget.onReminderAdded();

      Navigator.of(context).pop();
    } catch (err) {
      log("Error while saving new reminder: ${err}");
    }
  }

  void _updateReminder() async {
    DatabaseHelper dbHelper = DatabaseHelper();

    try {
      await dbHelper.updateReminder(widget.editingIndex, {
        'campus': selectedCampusIndex,
        'day': _dayOfWeekIndex,
        'time': _timeOfDayIndex,
      });

      widget.onReminderAdded();

      Navigator.of(context).pop();
    } catch (err) {
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

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.editingIndex >= 0;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              centerTitle: true,
              backgroundColor: Theme.of(context).colorScheme.background,
              title: Text(
                  isEditing
                      ? AppLocalizations.of(context)!.editReminder
                      : AppLocalizations.of(context)!.addReminder,
                  style: Theme.of(context).textTheme.labelSmall),
              scrolledUnderElevation: 0.2,
              actions: [
                isEditing
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          enableFeedback: false,
                          icon: Icon(
                            Icons.delete_forever_rounded,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          onPressed: () {
                            _deleteReminder();
                          },
                        ),
                      )
                    : SizedBox(),
              ],
              leading: IconButton(
                enableFeedback: false,
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
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
                                    textAlign: TextAlign.start),
                                VerticalSpacing(8.0),
                                Text(
                                    AppLocalizations.of(context)!
                                        .selectCampusReminder,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    textAlign: TextAlign.start),
                                VerticalSpacing(16.0),
                                DropdownButtonFormField<int>(
                                  isDense: true,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                    contentPadding: EdgeInsets.symmetric(
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
                                      .onBackground,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  hint: Text(
                                    AppLocalizations.of(context)!
                                        .yourCampusHint,
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary),
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
                                                .onBackground),
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
                                            .onBackground),
                                    textAlign: TextAlign.start),
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
                                            .onBackground),
                                    textAlign: TextAlign.start),
                                VerticalSpacing(12.0),
                                ChipsContainer(
                                  selectedChip: _timeOfDayIndex,
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
