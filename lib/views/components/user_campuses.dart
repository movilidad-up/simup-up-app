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
}