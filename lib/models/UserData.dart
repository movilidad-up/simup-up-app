import 'package:simup_up/enums/enums.dart';

class UserData {
  String userName;
  Zone userZone = Zone.unknown;
  bool termsAccepted = false;

  UserData({
    required this.userName
  });
}
