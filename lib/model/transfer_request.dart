import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_request.freezed.dart';
part 'transfer_request.g.dart';

@freezed
class TransferRequest with _$TransferRequest {
  const factory TransferRequest({
    required String requestId,
    required String deviceName,
    required String deviceId,
    required DateTime createdAt,
    String? description,
  }) = _TransferRequest;

  factory TransferRequest.fromJson(Map<String, dynamic> json) =>
      _$TransferRequestFromJson(json);
}

@freezed
class TransferApproval with _$TransferApproval {
  const factory TransferApproval({
    required String requestId,
    required bool approved,
    required DateTime respondedAt,
    bool? rememberDevice = false,
  }) = _TransferApproval;

  factory TransferApproval.fromJson(Map<String, dynamic> json) =>
      _$TransferApprovalFromJson(json);
}

@freezed
class TrustedDevice with _$TrustedDevice {
  const factory TrustedDevice({
    required String deviceId,
    required String deviceName,
    required String deviceFingerprint,
    required DateTime trustedSince,
    DateTime? lastUsed,
  }) = _TrustedDevice;

  factory TrustedDevice.fromJson(Map<String, dynamic> json) =>
      _$TrustedDeviceFromJson(json);
}

// Repository pour gérer les appareils de confiance
class TrustedDeviceRepository {
  static const storageKey = 'sharel_trusted_devices';

  // Get all trusted devices
  Future<List<TrustedDevice>> getTrustedDevices() async {
    // TODO: Implement with local storage (hive/shared_prefs)
    return [];
  }

  // Add device as trusted
  Future<void> addTrustedDevice(TrustedDevice device) async {
    // TODO: Implement with local storage
  }

  // Check if device is trusted
  Future<bool> isTrusted(String deviceId) async {
    final devices = await getTrustedDevices();
    return devices.any((d) => d.deviceId == deviceId);
  }

  // Remove from trusted
  Future<void> removeTrusted(String deviceId) async {
    // TODO: Implement
  }
}
