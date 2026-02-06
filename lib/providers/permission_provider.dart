import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/permission_service.dart';

final permissionServiceProvider = Provider((ref) => PermissionService());

final storagePermissionProvider = FutureProvider((ref) async {
  return await PermissionService.isStoragePermissionGranted();
});

final cameraPermissionProvider = FutureProvider((ref) async {
  return await PermissionService.isCameraPermissionGranted();
});

final requiredPermissionsProvider = FutureProvider((ref) async {
  return await PermissionService.getRequiredPermissions();
});

final requestStoragePermissionProvider = FutureProvider((ref) async {
  return await PermissionService.requestStoragePermission();
});

final requestCameraPermissionProvider = FutureProvider((ref) async {
  return await PermissionService.requestCameraPermission();
});
