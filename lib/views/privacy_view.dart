import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/styles/spaces.dart';

class PrivacyView extends StatelessWidget {
  const PrivacyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              centerTitle: true,
              elevation: 4,
              shadowColor: Colors.grey[100]!,
              backgroundColor: Theme.of(context).colorScheme.background,
              scrolledUnderElevation: 0.4,
              title: Text(
                AppLocalizations.of(context)!.privacyPolicyLabel,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  enableFeedback: false,
                  onPressed: () {
                    Navigator.of(context).pop();
                  }
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                // Privacy Policy Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.privacyPolicyTitle,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      VerticalSpacing(8.0),
                      Text(
                        AppLocalizations.of(context)!.lastUpdatedLabel,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      VerticalSpacing(16.0),
                      Text(
                        AppLocalizations.of(context)!.privacyPolicyText,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      VerticalSpacing(16.0),
                      Text(
                        AppLocalizations.of(context)!.informationWeCollectLabel,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      VerticalSpacing(8.0),
                      Text(
                        AppLocalizations.of(context)!.informationWeCollectText,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      VerticalSpacing(16.0),
                      Text(
                        AppLocalizations.of(context)!.howWeUseYourInformationLabel,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      VerticalSpacing(8.0),
                      Text(
                        AppLocalizations.of(context)!.howWeUseYourInformationText,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      VerticalSpacing(16.0),
                      Text(
                        AppLocalizations.of(context)!.dataStorageLabel,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      VerticalSpacing(8.0),
                      Text(
                        AppLocalizations.of(context)!.dataStorageText,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      VerticalSpacing(16.0),
                      Text(
                        AppLocalizations.of(context)!.yourChoicesLabel,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      VerticalSpacing(8.0),
                      Text(
                        AppLocalizations.of(context)!.yourChoicesText,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      VerticalSpacing(16.0),
                      Text(
                        AppLocalizations.of(context)!.securityLabel,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      VerticalSpacing(8.0),
                      Text(
                        AppLocalizations.of(context)!.securityText,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      VerticalSpacing(16.0),
                      Text(
                        AppLocalizations.of(context)!.childrensPrivacyLabel,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      VerticalSpacing(8.0),
                      Text(
                        AppLocalizations.of(context)!.childrensPrivacyText,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      VerticalSpacing(16.0),
                      Text(
                        AppLocalizations.of(context)!.changesToPrivacyPolicyLabel,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      VerticalSpacing(8.0),
                      Text(
                        AppLocalizations.of(context)!.changesToPrivacyPolicyText,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      VerticalSpacing(16.0),
                      Text(
                        AppLocalizations.of(context)!.contactUsLabel,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      VerticalSpacing(8.0),
                      Text(
                        AppLocalizations.of(context)!.contactUsText,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      VerticalSpacing(16.0)
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
