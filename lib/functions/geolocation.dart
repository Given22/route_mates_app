import 'package:permission_handler/permission_handler.dart';

Future<bool> locationPermision() async {
  ServiceStatus servicePermission;
  PermissionStatus permission;

  servicePermission = await Permission.locationWhenInUse.serviceStatus;
  if (servicePermission.isDisabled || servicePermission.isNotApplicable) {
    return false;
  }

  permission = await Permission.locationWhenInUse.status;
  if (permission == PermissionStatus.denied) {
    permission = await Permission.locationWhenInUse.request();
    if (permission == PermissionStatus.denied) {
      return false;
    }
  }

  if (permission == PermissionStatus.permanentlyDenied) {
    return false;
  }

  return true;
}
