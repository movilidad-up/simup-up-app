import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/enums/enums.dart';
import 'package:simup_up/models/UserData.dart';
import 'package:simup_up/views/components/user_zones.dart';
import 'package:simup_up/views/styles/spaces.dart';

class GetStartedZone extends StatefulWidget {
  final UserData userData;
  final ValueChanged<Zone> onZoneChanged;

  const GetStartedZone(
      {super.key, required this.userData, required this.onZoneChanged});

  @override
  State<GetStartedZone> createState() => _GetStartedZoneState();
}

class _GetStartedZoneState extends State<GetStartedZone> {
  int? selectedZoneIndex;

  @override
  void initState() {
    super.initState();
    selectedZoneIndex = null;
  }

  void handleZoneSelection(BuildContext context, int index) {
    setState(() {
      selectedZoneIndex = index;
    });
    widget.onZoneChanged(UserZones.zoneList[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.yourZoneName,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              height: 1.6,
              fontWeight: FontWeight.normal,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            textAlign: TextAlign.center,
            textScaler: const TextScaler.linear(1.0),
          ),
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
            iconEnabledColor: Theme.of(context).colorScheme.onSurface,
            icon: const Icon(Icons.keyboard_arrow_down),
            hint: Text(
                AppLocalizations.of(context)!.yourZoneNameHint,
              style: TextStyle(
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.tertiary
              ),
              textScaler: const TextScaler.linear(1.0),
            ),
            value: selectedZoneIndex,
            onChanged: (int? newValue) {
              if (newValue != null) {
                handleZoneSelection(context, newValue);
              }
            },
            items: UserZones.zoneNames(context)
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
                    color: Theme.of(context).colorScheme.onSurface
                  ),
                  textScaler: const TextScaler.linear(1.0),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}