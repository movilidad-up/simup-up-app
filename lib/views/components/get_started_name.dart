import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/models/UserData.dart';


class GetStartedName extends StatelessWidget {
  final UserData userData;
  final ValueChanged<String> onNameChanged;

  GetStartedName({super.key, required this.userData, required this.onNameChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          Text(
            AppLocalizations.of(context)!.yourName,
            style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                height: 1.6,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).colorScheme.tertiary),
            textAlign: TextAlign.center,
          ),
          TextFormField(
            textAlign:  TextAlign.center,
            onChanged: onNameChanged,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onBackground
            ),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.yourNameHint,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.background,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
        ]
    );
  }
}
