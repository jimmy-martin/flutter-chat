import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  init() async {
    if (Platform.isIOS) {
      PermissionStatus status = await Permission.photos.status;
      checkStatusPhotos(status);
    } else {
      PermissionStatus status = await Permission.storage.status;
      checkStatusStorage(status);
    }
  }

  checkStatusPhotos(PermissionStatus permissionStatus) {
    switch (permissionStatus) {
      case PermissionStatus.permanentlyDenied:
        return Future.error("Accès refusé");
      case PermissionStatus.denied:
        return Permission.photos.request();
      case PermissionStatus.restricted:
        return Permission.photos.request();
      case PermissionStatus.limited:
        return Permission.photos.request();
      case PermissionStatus.granted:
        return permissionStatus;
      default:
        return Future.error("Aucun statut présent!");
    }
  }

  checkStatusStorage(PermissionStatus permissionStatus) {
    switch (permissionStatus) {
      case PermissionStatus.permanentlyDenied:
        return Future.error("Accès refusé");
      case PermissionStatus.denied:
        return Permission.photos.request();
      case PermissionStatus.restricted:
        return Permission.photos.request();
      case PermissionStatus.limited:
        return Permission.photos.request();
      case PermissionStatus.granted:
        return permissionStatus;
      default:
        return Future.error("Aucun statut présent!");
    }
  }
}
