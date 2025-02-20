import 'package:flutter/material.dart';
import 'package:simup_up/enums/enums.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:simup_up/views/utils/beacon_checker.dart';
import 'package:simup_up/views/utils/status_radar_utils.dart';
import 'custom_toast.dart';

class StatusRadar extends StatefulWidget {
  final RadarStatus currentStatus;
  const StatusRadar({Key? key, this.currentStatus = RadarStatus.ready}) : super(key: key);

  @override
  State<StatusRadar> createState() => _StatusRadarState();
}

class _StatusRadarState extends State<StatusRadar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  RadarStatus currentStatus = RadarStatus.ready;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<RadarStatus> sendAttendance() async {
    await Future.delayed(Duration(seconds: 3));
    return RadarStatus.success;
  }

  Future<void> _handleAttendanceSubmission() async {
    setState(() {
      currentStatus = RadarStatus.scanning;
      _controller.repeat(reverse: true);
    });

    currentStatus = await BeaconChecker.checkBeaconStatus();

    if (currentStatus == RadarStatus.sending) {
      setState(() {
        currentStatus = RadarStatus.sending;
      });

      currentStatus = await sendAttendance();
    }

    setState(() {
      if (currentStatus == RadarStatus.success) {
        CustomToast.buildToast(
          context,
          const Color(0xFF44B300),
          AppLocalizations.of(context)!.beaconAttendanceSent,
          AppLocalizations.of(context)!.beaconAttendanceSentInfo,
          Icons.check_circle,
        );
      } else {
        CustomToast.buildToast(
          context,
          const Color(0xFFE40000),
          AppLocalizations.of(context)!.beaconAttendanceFailed,
          AppLocalizations.of(context)!.beaconAttendanceFailedInfo,
          Icons.error_rounded,
        );
      }
      _controller.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    bool isProcessing = currentStatus == RadarStatus.scanning || currentStatus == RadarStatus.sending;
    bool isSuccess = currentStatus == RadarStatus.success;

    return InkWell(
      onTap: (!isProcessing && !isSuccess) ? _handleAttendanceSubmission : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _opacityAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: isProcessing ? _opacityAnimation.value : 0.4,
                      child: Container(
                        width: 120.0,
                        height: 120.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: StatusRadarUtils.statusColors[currentStatus]!.withOpacity(0.2),
                        ),
                      ),
                    );
                  },
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: StatusRadarUtils.statusColors[currentStatus],
                    borderRadius: BorderRadius.circular(64.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(
                      StatusRadarUtils.statusIcons[currentStatus],
                      color: Colors.white,
                      size: 32.0,
                    ),
                  ),
                ),
              ],
            ),
            VerticalSpacing(16.0),
            SizedBox(
              width: screenWidth * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    StatusRadarUtils.getStatusText(context, currentStatus),
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  VerticalSpacing(4.0),
                  Text(
                    StatusRadarUtils.getStatusInfoText(context, currentStatus),
                    style: Theme.of(context).textTheme.labelLarge,
                    textAlign: TextAlign.center,
                  ),
                  if (isSuccess) ...[
                    VerticalSpacing(16.0),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        "Regresar",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
