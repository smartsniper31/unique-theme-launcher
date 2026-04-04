import 'package:permission_handler/permission_handler.dart';

class PermissionsHelper {
  /// Version 11.0.0+ compatible
  static Future<Map<Permission, PermissionStatus>> requestAllWithRetry() async {
    final permissions = [
      Permission.contacts,
      Permission.sms,
      Permission.phone,
    ];
    
    final Map<Permission, PermissionStatus> results = {};
    
    for (final permission in permissions) {
      final status = await permission.request();
      results[permission] = status;
      
      if (status.isDenied && !status.isPermanentlyDenied) {
        // Deuxième tentative
        final secondStatus = await permission.request();
        results[permission] = secondStatus;
      }
    }
    
    return results;
  }

  static bool hasEssentialPermissions(Map<Permission, PermissionStatus> results) {
    return results[Permission.contacts]?.isGranted == true || 
           results[Permission.sms]?.isGranted == true;
  }
}
