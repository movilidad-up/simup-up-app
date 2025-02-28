import 'package:flutter/material.dart';
import 'package:simup_up/enums/enums.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatusRadarUtils {
  static const Map<RadarStatus, Color> statusColors = {
    RadarStatus.ready: Colors.blue,
    RadarStatus.scanning: Colors.blue,
    RadarStatus.sending: Colors.orangeAccent,
    RadarStatus.tooFar: Colors.red,
    RadarStatus.noSignal: Colors.redAccent,
    RadarStatus.bluetoothDisabled: Colors.grey,
    RadarStatus.success: Colors.green,
    RadarStatus.successQueue: Colors.greenAccent,
  };

  static const Map<RadarStatus, IconData> statusIcons = {
    RadarStatus.ready: Icons.send_rounded,
    RadarStatus.scanning: Icons.bluetooth_searching_rounded,
    RadarStatus.sending: Icons.cloud_upload,
    RadarStatus.tooFar: Icons.pin_drop_rounded,
    RadarStatus.noSignal: Icons.wifi_tethering_error_rounded,
    RadarStatus.bluetoothDisabled: Icons.bluetooth_disabled,
    RadarStatus.success: Icons.check_circle,
    RadarStatus.successQueue: Icons.cloud_sync_rounded,
  };

  static String getStatusText(BuildContext context, RadarStatus status) {
    return {
      RadarStatus.ready: AppLocalizations.of(context)!.readyStatus,
      RadarStatus.scanning: AppLocalizations.of(context)!.scanStatus,
      RadarStatus.sending: AppLocalizations.of(context)!.sendStatus,
      RadarStatus.tooFar: AppLocalizations.of(context)!.rangeStatus,
      RadarStatus.noSignal: AppLocalizations.of(context)!.unknownStatus,
      RadarStatus.bluetoothDisabled: AppLocalizations.of(context)!.disabledStatus,
      RadarStatus.success: AppLocalizations.of(context)!.successStatus,
      RadarStatus.successQueue: AppLocalizations.of(context)!.successQueueStatus,
    }[status]!;
  }

  static String getStatusInfoText(BuildContext context, RadarStatus status) {
    return {
      RadarStatus.ready: AppLocalizations.of(context)!.readyStatusInfo,
      RadarStatus.scanning: AppLocalizations.of(context)!.scanStatusInfo,
      RadarStatus.sending: AppLocalizations.of(context)!.sendStatusInfo,
      RadarStatus.tooFar: AppLocalizations.of(context)!.rangeStatusInfo,
      RadarStatus.noSignal: AppLocalizations.of(context)!.unknownStatusInfo,
      RadarStatus.bluetoothDisabled: AppLocalizations.of(context)!.disabledStatusInfo,
      RadarStatus.success: AppLocalizations.of(context)!.successStatusInfo,
      RadarStatus.successQueue: AppLocalizations.of(context)!.successQueueStatusInfo,
    }[status]!;
  }
}
