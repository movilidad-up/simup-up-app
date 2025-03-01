import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/enums/enums.dart';
import 'package:simup_up/models/UserData.dart';
import 'package:simup_up/views/privacy_view.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:simup_up/views/terms_view.dart';
import 'package:simup_up/views/utils/custom-page-router.dart';

class GetStartedTerms extends StatefulWidget {
  final UserData userData;
  final ValueChanged<bool> onTermsAccepted;

  const GetStartedTerms(
      {super.key, required this.userData, required this.onTermsAccepted});

  @override
  State<GetStartedTerms> createState() => _GetStartedTermsState();
}

Widget _buildTermItem(BuildContext context, String termTitle, termInfo, IconData icon) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      DecoratedBox(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0),
              color: Theme.of(context).colorScheme.surfaceContainer),
          child: Padding(padding: EdgeInsets.all(12.0),
          child: Icon(icon, color: Theme.of(context).colorScheme.onSurface, size: 24.0))
      ),
      HorizontalSpacing(16.0),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              termTitle,
              style: Theme.of(context).textTheme.headlineMedium,
              textScaler: TextScaler.linear(1.0),
            ),
            VerticalSpacing(4.0),
            Text(
              termInfo,
              style: Theme.of(context).textTheme.labelLarge,
              textScaler: TextScaler.linear(1.0),
            )
          ],
        ),
      )
    ],
  );
}

class _GetStartedTermsState extends State<GetStartedTerms> {
  bool? termsAccepted;

  void handleTermsCheckbox(bool? value) {
    bool accepted = value ?? false;
    setState(() {
      termsAccepted = accepted;
    });
    widget.onTermsAccepted(accepted);
  }

  @override
  void initState() {
    super.initState();
    termsAccepted = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.termsOfService,
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.start,
            textScaler: const TextScaler.linear(1.0),
          ),
          VerticalSpacing(8.0),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                TextSpan(
                    text: AppLocalizations.of(context)!.termsOfServiceInfo1),
                TextSpan(
                  text: AppLocalizations.of(context)!.termsOfServiceInfo2,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).push(CustomPageRoute(const TermsView()));
                    },
                ),
                TextSpan(
                    text: AppLocalizations.of(context)!.termsOfServiceInfo3),
                TextSpan(
                  text: AppLocalizations.of(context)!.termsOfServiceInfo4,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).push(CustomPageRoute(const PrivacyView()));
                    },
                ),
                TextSpan(
                    text: AppLocalizations.of(context)!.termsOfServiceInfo5),
              ],
            ),
          ),
          VerticalSpacing(24.0),
          SizedBox(
            width: MediaQuery.of(context).size.width - 48,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTermItem(context, AppLocalizations.of(context)!.appUsage, AppLocalizations.of(context)!.appUsageInfo, Icons.directions_bus_rounded),
                  VerticalSpacing(16.0),
                  _buildTermItem(context, AppLocalizations.of(context)!.digitalSignatureAndData, AppLocalizations.of(context)!.digitalSignatureInfoTerms, Icons.draw_rounded),
                  VerticalSpacing(16.0),
                  _buildTermItem(context, AppLocalizations.of(context)!.security, AppLocalizations.of(context)!.securityInfo, Icons.lock_rounded),
                  VerticalSpacing(16.0),
                  _buildTermItem(context, AppLocalizations.of(context)!.dataRetentionAndDeletion, AppLocalizations.of(context)!.dataRetention, Icons.history),
                ],
              ),
            ),
          ),
          VerticalSpacing(8.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                value: termsAccepted,
                onChanged: handleTermsCheckbox,
                side: BorderSide(color: Color(0xff585858)),
                visualDensity: VisualDensity(vertical: 3.0),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    handleTermsCheckbox(!termsAccepted!);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.readAndAcceptTerms,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
