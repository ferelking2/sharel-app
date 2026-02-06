import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static int _getAndroidVersion() {
    try {
      return int.tryParse(Platform.version.split('.').first) ?? 31;
    } catch (_) {
      return 31;
    }
  }

  /// Request storage permission with proper Android version handling
  static Future<PermissionStatus> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final version = _getAndroidVersion();
      if (version >= 13) {
        return await Permission.photos.request();
      } else if (version >= 11) {
        return await Permission.manageExternalStorage.request();
      } else {
        return await Permission.storage.request();
      }
    } else if (Platform.isIOS) {
      return await Permission.photos.request();
    }
    return PermissionStatus.granted;
  }

  /// Request camera permission
  static Future<PermissionStatus> requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isDenied) {
      return status;
    }
    if (status.isPermanentlyDenied) {
      _logPermissionDenied('Camera');
    }
    return status;
  }

  /// Request nearby wifi devices permission (Android 13+)
  static Future<PermissionStatus> requestNearbyWifiPermission() async {
    if (!Platform.isAndroid) return PermissionStatus.granted;
    
    final version = _getAndroidVersion();
    if (version < 13) return PermissionStatus.granted;
    
    final status = await Permission.nearbyWifiDevices.request();
    if (status.isDenied) {
      return status;
    }
    if (status.isPermanentlyDenied) {
      _logPermissionDenied('Nearby Wifi Devices');
    }
    return status;
  }

  /// Get all required permissions status
  static Future<Map<String, PermissionStatus>> getRequiredPermissions() async {
    final perms = <String, PermissionStatus>{};
    
    if (Platform.isAndroid) {
      final version = _getAndroidVersion();
      
      if (version >= 13) {
        perms['Photos'] = await Permission.photos.status;
        perms['Videos'] = await Permission.videos.status;
        perms['Audio'] = await Permission.audio.status;
      } else if (version >= 11) {
        perms['Manage External Storage'] = await Permission.manageExternalStorage.status;
      } else {
        perms['Storage'] = await Permission.storage.status;
      }
      
      perms['Camera'] = await Permission.camera.status;
      perms['Contacts'] = await Permission.contacts.status;
      
      if (version >= 13) {
        perms['Nearby Wifi Devices'] = await Permission.nearbyWifiDevices.status;
      }
    } else if (Platform.isIOS) {
      perms['Photos'] = await Permission.photos.status;
      perms['Camera'] = await Permission.camera.status;
      perms['Contacts'] = await Permission.contacts.status;
    }
    
    return perms;
  }

  /// Check if storage permission is granted
  static Future<bool> isStoragePermissionGranted() async {
    if (Platform.isAndroid) {
      final version = _getAndroidVersion();
      if (version >= 13) {
        return await Permission.photos.isGranted;
      } else if (version >= 11) {
        return await Permission.manageExternalStorage.isGranted;
      }
    }
    return await Permission.storage.isGranted;
  }

  /// Check if camera permission is granted
  static Future<bool> isCameraPermissionGranted() async {
    return await Permission.camera.isGranted;
  }

  /// Check if nearby wifi permission is granted
  static Future<bool> isNearbyWifiPermissionGranted() async {
    if (!Platform.isAndroid) return true;
    if (_getAndroidVersion() < 13) return true;
    return await Permission.nearbyWifiDevices.isGranted;
  }

  /// Open app settings for permission management
  static Future<bool> openAppSettings() async {
    return await openAppSettings();
  }

  /// Log permission denial
  static void _logPermissionDenied(String permissionName) {
    // ignore: avoid_print
    print('[PermissionService] $permissionName permission was permanently denied. '
        'User should go to Settings to enable it.');
  }

  /// Helper to get user-friendly permission name
  static String getPermissionLabel(String key) {
    final labels = {
      'Storage': 'Stockage',
      'Photos': 'Photos',
      'Videos': 'Vidéos',
      'Audio': 'Audio',
      'Camera': 'Appareil photo',
      'Contacts': 'Contacts',
      'Nearby Wifi Devices': 'Appareils à proximité',
      'Manage External Storage': 'Accès fichiers',
    };
    return labels[key] ?? key;
  }
}
