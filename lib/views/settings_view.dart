import 'package:flutter/material.dart';
import 'package:simup_up/views/components/checkbox-item.dart';
import 'package:simup_up/views/components/option-item.dart';
import 'package:simup_up/views/dashboard_view.dart';
import 'package:simup_up/views/privacy_view.dart';
import 'package:simup_up/views/special_view.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:simup_up/views/terms_view.dart';
import 'package:simup_up/views/utils/custom-page-router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              centerTitle: true,
              elevation: 4,
              shadowColor: Colors.grey[100]!,
              backgroundColor: Theme.of(context).colorScheme.surface,
              scrolledUnderElevation: 0.4,
              title: Text(
                AppLocalizations.of(context)!.settingsTitle,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  enableFeedback: false,
                  onPressed: () {
                    Navigator.of(context).pop();
                  }
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, right: 24.0, bottom: 4.0, left: 24.0),
                  child: Text(AppLocalizations.of(context)!.notificationsSection, textAlign: TextAlign.start, style: Theme.of(context).textTheme.headlineSmall),
                ),
                CheckboxItem(
                  label: AppLocalizations.of(context)!.taskReminderLabel,
                  description: AppLocalizations.of(context)!.taskReminderDescription,
                  preferenceKey: 'enableReminders',
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, right: 24.0, bottom: 4.0, left: 24.0),
                  child: Text(AppLocalizations.of(context)!.aboutSection, textAlign: TextAlign.start, style: Theme.of(context).textTheme.headlineSmall),
                ),
                OptionItem(label: AppLocalizations.of(context)!.versionLabel, description: AppLocalizations.of(context)!.versionDescription, isClickable: false, onTap: (){}),
                OptionItem(label: AppLocalizations.of(context)!.termsLabel, description: AppLocalizations.of(context)!.termsDescription, isClickable: true, onTap: (){
                  Navigator.of(context).push(CustomPageRoute(const TermsView()));
                }),
                OptionItem(
                    label: AppLocalizations.of(context)!.privacyPolicyLabel,
                    description: AppLocalizations.of(context)!.privacyPolicyDescription,
                    isClickable: true,
                    onTap: (){
                      Navigator.of(context).push(CustomPageRoute(const PrivacyView()));
                    }
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, right: 24.0, bottom: 4.0, left: 24.0),
                  child: Text(AppLocalizations.of(context)!.otherSection, textAlign: TextAlign.start, style: Theme.of(context).textTheme.headlineSmall),
                ),
                OptionItem(
                    label: AppLocalizations.of(context)!.specialLabel,
                    description: AppLocalizations.of(context)!.specialDescription,
                    isClickable: true,
                    onTap: (){
                      Navigator.of(context).push(CustomPageRoute(const SpecialView()));
                    }),
                VerticalSpacing(16.0)
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
