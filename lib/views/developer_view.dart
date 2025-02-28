import 'package:flutter/material.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeveloperView extends StatelessWidget {
  const DeveloperView({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
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
                AppLocalizations.of(context)!.developmentLabel,
                style: Theme.of(context).textTheme.labelLarge,
                textScaler: const TextScaler.linear(1.0),
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
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.developedBy,
                        style: Theme.of(context).textTheme.headlineMedium,
                        textScaler: const TextScaler.linear(1.0),
                      ),
                      VerticalSpacing(8.0),
                      Text(
                        "Joel Torres",
                        style: Theme.of(context).textTheme.headlineMedium,
                        textScaler: const TextScaler.linear(1.0),
                      ),
                      VerticalSpacing(4.0),
                      Text(
                        "Estudiante de Ingenieria de Sistemas\nUniversidad de Pamplona\nSede Villa del Rosario",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      VerticalSpacing(8.0),
                      Text(
                        "Un mensaje especial",
                        style: Theme.of(context).textTheme.headlineMedium,
                        textScaler: const TextScaler.linear(1.0),
                      ),
                      VerticalSpacing(4.0),
                      Text(
                        AppLocalizations.of(context)!.devLetter,
                        style: Theme.of(context).textTheme.labelLarge,
                        textScaler: const TextScaler.linear(1.0),
                      ),
                      VerticalSpacing(24.0),
                      Center(
                        child: Image.asset(
                            "assets/images/illustrations/lionel.png",
                          width: screenWidth * 0.8,
                        ),
                      ),
                      VerticalSpacing(16.0),
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
