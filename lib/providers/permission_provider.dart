import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/permission_service.dart';
import './role_provider.dart';

final permissionServiceProvider = Provider((ref) => PermissionService());

final storagePermissionProvider = FutureProvider((ref) async {
  return await PermissionService.isStoragePermissionGranted();
});

final cameraPermissionProvider = FutureProvider((ref) async {
  return await PermissionService.isCameraPermissionGranted();
});

/// Get required permissions based on transfer role (sender or receiver)
/// Sender skips Camera and All Files (already requested at startup)
/// Receiver includes all permissions
final requiredPermissionsProvider = FutureProvider((ref) async {
  final role = ref.watch(transferRoleProvider);
  final isSender = role == TransferRole.sender;
  return await PermissionService.getRequiredPermissions(isSender: isSender);
});

final requestStoragePermissionProvider = FutureProvider((ref) async {
  return await PermissionService.requestStoragePermission();
});

final requestCameraPermissionProvider = FutureProvider((ref) async {
  return await PermissionService.requestCameraPermission();
});

