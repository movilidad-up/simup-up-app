import 'package:flutter/material.dart';
import 'package:simup_up/views/components/schedule_tabs.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SchedulesView extends StatefulWidget {
  const SchedulesView({super.key});

  @override
  State<SchedulesView> createState() => _SchedulesViewState();
}

class _SchedulesViewState extends State<SchedulesView> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: Theme.of(context).colorScheme.surface,
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.schedule,
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
            child: SizedBox(
              height: screenHeight,
              width: screenWidth,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 16.0, bottom: 0.0, left: 24.0, right: 24.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        width: screenWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                AppLocalizations.of(context)!.schedules,
                                style: Theme.of(context).textTheme.displayMedium,
                                textAlign: TextAlign.start,
                                textScaler: const TextScaler.linear(1.0),
                            ),
                            VerticalSpacing(8.0),
                            Text(AppLocalizations.of(context)!.schedulesDescription,
                                style: Theme.of(context).textTheme.bodySmall,
                                textAlign: TextAlign.start,
                                textScaler: const TextScaler.linear(1.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  VerticalSpacing(24.0),
                  const Expanded(
                      child: ScheduleTabs()
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
