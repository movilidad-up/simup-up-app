import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/enums/enums.dart';

class UserCampus {
  static List<Campus> campusList = [
    Campus.villaCampus,
    Campus.creadCampus,
    Campus.healthCampus
  ];

  static List<String> campusNames(BuildContext context) => [
    AppLocalizations.of(context)!.villaCampus,
    AppLocalizations.of(context)!.creadCampus,
    AppLocalizations.of(context)!.healthCampus
  ];

  static List<String> daysOfWeek(BuildContext context) => [
    AppLocalizations.of(context)!.monday,
    AppLocalizations.of(context)!.tuesday,
    AppLocalizations.of(context)!.wednesday,
    AppLocalizations.of(context)!.thursday,
    AppLocalizations.of(context)!.friday,
    AppLocalizations.of(context)!.saturday,
  ];

  static List<String> operationTimes = [
    "6:00 A.M.",
    "8:00 A.M.",
    "10:00 A.M.",
    "12:00 P.M",
    "02:00 P.M.",
    "04:00 P.M.",
    "6:00 P.M."
  ];
}