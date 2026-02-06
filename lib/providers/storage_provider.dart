import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

final storageServiceProvider = Provider((ref) => StorageService());

final storageStatsProvider = FutureProvider((ref) async {
  final storage = ref.watch(storageServiceProvider);
  return await storage.getStorageStats();
});

final sharelsRootPathProvider = Provider((ref) {
  final storage = ref.watch(storageServiceProvider);
  return storage.getSharelsRoot().path;
});

final downloadsPathProvider = Provider((ref) {
  final storage = ref.watch(storageServiceProvider);
  return storage.getDownloadsDir().path;
});

final logsPathProvider = Provider((ref) {
  final storage = ref.watch(storageServiceProvider);
  return storage.getLogsDir().path;
});
