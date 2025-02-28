import 'package:simup_up/views/utils/update-observable.dart';

class UpdateNotification {
  static final UpdateObservable updateObservable = UpdateObservable();

  static void notifyUpdate() {
    updateObservable.notify();
  }
}