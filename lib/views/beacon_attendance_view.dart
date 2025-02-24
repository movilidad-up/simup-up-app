import 'package:flutter/material.dart';
import 'package:simup_up/enums/enums.dart';
import 'package:simup_up/views/components/attendance-card.dart';
import 'package:simup_up/views/components/status_radar.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BeaconAttendanceView extends StatefulWidget {
  const BeaconAttendanceView({Key? key}) : super(key: key);

  @override
  State<BeaconAttendanceView> createState() => _BeaconAttendanceViewState();
}

class _BeaconAttendanceViewState extends State<BeaconAttendanceView> {
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
                AppLocalizations.of(context)!.attendance,
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
                          AppLocalizations.of(context)!.beaconAttendance,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          AppLocalizations.of(context)!.beaconAttendanceInfo,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                // SubmitAttendanceButton(),
                VerticalSpacing(24.0),
                StatusRadar(currentStatus: RadarStatus.ready)
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
