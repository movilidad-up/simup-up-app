import 'package:flutter/material.dart';
import 'package:simup_up/views/components/chips_container.dart';
import 'package:simup_up/views/components/primary_button.dart';
import 'package:simup_up/views/components/user_campuses.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddNotificationView extends StatefulWidget {
  const AddNotificationView({super.key});

  @override
  State<AddNotificationView> createState() => _AddNotificationViewState();
}

class _AddNotificationViewState extends State<AddNotificationView> {
  int? selectedCampusIndex;
  int _dayOfWeekIndex = -1;
  int _timeOfDayIndex = -1;

  void _createNewReminder() {
    print("New reminder was created for $selectedCampusIndex every $_dayOfWeekIndex at $_timeOfDayIndex.");
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
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              centerTitle: true,
              backgroundColor: Theme.of(context).colorScheme.background,
              title: Text("Añadir recordatorio",
                  style: Theme.of(context).textTheme.labelSmall
              ),
              scrolledUnderElevation: 0.2,
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
                                Text("Añadir recordatorio",
                                    style: Theme.of(context).textTheme.displayMedium,
                                    textAlign: TextAlign.start),
                                VerticalSpacing(8.0),
                                Text(
                                    "Selecciona la sede, días y horas de llegada",
                                    style: Theme.of(context).textTheme.bodySmall,
                                    textAlign: TextAlign.start),
                                VerticalSpacing(16.0),
                                DropdownButtonFormField<int>(
                                  isDense: true,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Theme.of(context).colorScheme.onSurfaceVariant,
                                    contentPadding:
                                    EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      borderSide:
                                      BorderSide(color: Theme.of(context).colorScheme.outline, width: 0.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      borderSide:
                                      BorderSide(color: Theme.of(context).colorScheme.outline, width: 0.0),
                                    ),
                                    border: const OutlineInputBorder(),
                                  ),
                                  iconEnabledColor: Theme.of(context).colorScheme.onBackground,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  hint: Text(
                                    AppLocalizations.of(context)!.yourCampusHint,
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Theme.of(context).colorScheme.tertiary
                                    ),
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
                                            color: Theme.of(context).colorScheme.onBackground
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                VerticalSpacing(16.0),
                                Text("Notificarme los días",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0,
                                      color: Theme.of(context).colorScheme.onBackground
                                    ),
                                    textAlign: TextAlign.start),
                                VerticalSpacing(12.0),
                                ChipsContainer(
                                  selectedChip: _dayOfWeekIndex,
                                  chipList: const ["Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado"],
                                  onCardSelected: (index) {
                                    handleDaySelection(index);
                                  },
                                ),
                                VerticalSpacing(16.0),
                                Text("En las horas",
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                        color: Theme.of(context).colorScheme.onBackground
                                    ),
                                    textAlign: TextAlign.start),
                                VerticalSpacing(12.0),
                                ChipsContainer(
                                  selectedChip: _timeOfDayIndex,
                                  chipList: const ["6:00 A.M.", "8:00 A.M.", "10:00 A.M.", "12:00 P.M", "02:00 P.M.", "04:00 P.M.", "6:00 P.M."],
                                  onCardSelected: (index) {
                                    handleTimeSelection(index);
                                  },
                                ),
                                VerticalSpacing(24.0),
                                PrimaryButton(
                                    buttonText: AppLocalizations.of(context)!.createReminder,
                                    hasPadding: false,
                                    onButtonPressed: (){
                                      _createNewReminder();
                                    },
                                    isButtonEnabled: true
                                )
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
