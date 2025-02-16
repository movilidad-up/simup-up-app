import 'package:flutter/material.dart';
import 'package:simup_up/views/components/attendance-card.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'components/action_card.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
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
                AppLocalizations.of(context)!.history,
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
                  padding: const EdgeInsets.only(
                      top: 16.0, bottom: 16.0, left: 24.0, right: 24.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.history,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          AppLocalizations.of(context)!.historyDescription,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.myRecentAttendance,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          textScaler: const TextScaler.linear(1.0),
                        ),
                        SizedBox(height: 4.0),
                        VerticalSpacing(16.0),
                        AttendanceCard(
                          date: "20/02/2025 a las 12:00 P.M.",
                          route: "1",
                        ),
                        VerticalSpacing(8.0),
                        AttendanceCard(
                          date: "20/02/2025 a las 12:00 P.M.",
                          route: "1",
                        ),
                        VerticalSpacing(8.0),
                        AttendanceCard(
                          date: "20/02/2025 a las 12:00 P.M.",
                          route: "1",
                        ),
                      ],
                    ),
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
