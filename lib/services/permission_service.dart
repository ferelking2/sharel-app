import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

class PermissionService {
  static int _getAndroidVersion() {
    try {
      return int.tryParse(Platform.version.split('.').first) ?? 31;
    } catch (_) {
      return 31;
    }
  }

  /// Request ALL FILES ACCESS (MANAGE_EXTERNAL_STORAGE)
  /// This is the PRIMARY permission needed for SHAREL functionality
  static Future<PermissionStatus> requestAllFilesAccess() async {
    if (!Platform.isAndroid) {
      debugPrint('[PermissionService] Host is not Android, skipping MANAGE_EXTERNAL_STORAGE');
      return PermissionStatus.granted;
    }

    final version = _getAndroidVersion();
    debugPrint('[PermissionService] Android version: $version');
    
    if (version >= 11) {
      debugPrint('[PermissionService] Requesting MANAGE_EXTERNAL_STORAGE (Android 11+)...');
      final status = await Permission.manageExternalStorage.request();
      debugPrint('[PermissionService] MANAGE_EXTERNAL_STORAGE response: $status');
      
      if (status.isGranted) {
        debugPrint('[PermissionService] ✓ MANAGE_EXTERNAL_STORAGE granted');
      } else if (status.isPermanentlyDenied) {
        debugPrint('[PermissionService] ⚠️ MANAGE_EXTERNAL_STORAGE is permanently denied');
      } else {
        debugPrint('[PermissionService] ⚠️ MANAGE_EXTERNAL_STORAGE was denied');
      }
      return status;
    } else {
      debugPrint('[PermissionService] Requesting READ_EXTERNAL_STORAGE (Android ≤10)...');
      final status = await Permission.storage.request();
      debugPrint('[PermissionService] READ_EXTERNAL_STORAGE response: $status');
      return status;
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

  /// Get all required permissions status (with optional role filtering)
  /// Sender (client) role skips Camera and All Files Access (already requested at startup)
  /// Receiver (host) role includes all permissions
  static Future<Map<String, PermissionStatus>> getRequiredPermissions({bool isSender = false}) async {
    final perms = <String, PermissionStatus>{};

    if (Platform.isAndroid) {
      final version = _getAndroidVersion();

      // Receiver requests All Files Access; Sender skips (already requested at startup)
      if (!isSender) {
        perms['All Files Access'] = await Permission.manageExternalStorage.status;
      }

      if (version >= 13) {
        perms['Photos'] = await Permission.photos.status;
        perms['Videos'] = await Permission.videos.status;
        perms['Audio'] = await Permission.audio.status;
      }

      // Only request Camera if specifically needed (receiver for QR scanning)
      // Sender should request Camera only when opening QR scanner
      if (!isSender) {
        perms['Camera'] = await Permission.camera.status;
      }

      perms['Contacts'] = await Permission.contacts.status;

      if (version >= 13) {
        perms['Nearby Wifi Devices'] = await Permission.nearbyWifiDevices.status;
      }
    } else if (Platform.isIOS) {
      perms['Photos'] = await Permission.photos.status;
      perms['Contacts'] = await Permission.contacts.status;

      // Only Camera for receiver (QR scanning)
      if (!isSender) {
        perms['Camera'] = await Permission.camera.status;
      }
    }

    return perms;
  }

  /// Check if ALL FILES ACCESS is granted (critical for SHAREL)
  static Future<bool> isAllFilesAccessGranted() async {
    if (!Platform.isAndroid) return true;
    if (_getAndroidVersion() < 11) return true;
    
    final status = await Permission.manageExternalStorage.status;
    return status.isGranted;
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
      'All Files Access': 'Accès à tous les fichiers',
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
