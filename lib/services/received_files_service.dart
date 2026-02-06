import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sharel_app/services/storage_service.dart';
import 'package:sharel_app/model/selected_item.dart';

/// Service pour gérer la réception et l'organisation des fichiers
class ReceivedFilesService {
  static final ReceivedFilesService _instance = ReceivedFilesService._internal();
  
  factory ReceivedFilesService() {
    return _instance;
  }
  
  ReceivedFilesService._internal();

  /// Déterminer le type MIME d'un fichier basé sur son extension
  String _getMediaTypeFromPath(String filePath) {
    final extension = filePath.toLowerCase().split('.').last;
    
    // Vidéo
    if (['mp4', 'mkv', 'avi', 'mov', 'webm', 'flv', '3gp'].contains(extension)) {
      return 'video';
    }
    
    // Photo/Image
    if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'svg'].contains(extension)) {
      return 'photo';
    }
    
    // Audio/Music
    if (['mp3', 'wav', 'm4a', 'flac', 'aac', 'ogg', 'wma'].contains(extension)) {
      return 'audio';
    }
    
    // Documents
    if (['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt', 'rtf', 'odt'].contains(extension)) {
      return 'document';
    }
    
    // Apps
    if (['apk', 'app', 'exe', 'dmg'].contains(extension)) {
      return 'app';
    }
    
    // Archive
    if (['zip', 'rar', '7z', 'tar', 'gz', 'bz2'].contains(extension)) {
      return 'archive';
    }
    
    return 'other';
  }

  /// Sauvegarder un fichier reçu dans le bon dossier
  Future<File> saveReceivedFile(
    String fileName,
    List<int> fileData,
  ) async {
    try {
      final mediaType = _getMediaTypeFromPath(fileName);
      final destDir = StorageService().getReceivedItemDir(mediaType);
      
      // S'assurer que le répertoire existe
      if (!destDir.existsSync()) {
        await destDir.create(recursive: true);
      }
      
      final destFile = File('${destDir.path}/$fileName');
      
      // Si le fichier existe déjà, ajouter un suffixe
      File finalFile = destFile;
      if (destFile.existsSync()) {
        final baseName = fileName.split('.').first;
        final extension = fileName.split('.').last;
        int counter = 1;
        
        while (finalFile.existsSync()) {
          final newName = '${baseName}_($counter).$extension';
          finalFile = File('${destDir.path}/$newName');
          counter++;
        }
      }
      
      // Écrire le fichier
      await finalFile.writeAsBytes(fileData);
      debugPrint('[ReceivedFilesService] Saved: ${finalFile.path}');
      
      return finalFile;
    } catch (e) {
      debugPrint('[ReceivedFilesService] Error saving file: $e');
      rethrow;
    }
  }

  /// Obtenir la liste des fichiers reçus groupés par type
  Future<Map<String, List<File>>> getReceivedFilesByType() async {
    try {
      final result = <String, List<File>>{};
      final downloadsDir = StorageService().getDownloadsDir();
      
      if (!downloadsDir.existsSync()) {
        return result;
      }
      
      final categories = [
        'Received_Photos',
        'Received_Videos',
        'Received_Audio',
        'Received_Documents',
        'Received_Apps',
        'Received_Other',
      ];
      
      for (final category in categories) {
        final dir = Directory('${downloadsDir.path}/$category');
        if (dir.existsSync()) {
          final files = dir
              .listSync()
              .whereType<File>()
              .toList();
          
          result[category.replaceFirst('Received_', '')] = files;
        }
      }
      
      return result;
    } catch (e) {
      debugPrint('[ReceivedFilesService] Error getting received files: $e');
      return {};
    }
  }

  /// Obtenir les statistiques des fichiers reçus
  Future<ReceivedFilesStats> getStats() async {
    try {
      final filesByType = await getReceivedFilesByType();
      int totalFiles = 0;
      int totalSizeBytes = 0;
      
      for (final list in filesByType.values) {
        for (final file in list) {
          totalFiles++;
          totalSizeBytes += file.lengthSync();
        }
      }
      
      return ReceivedFilesStats(
        totalFiles: totalFiles,
        totalSizeBytes: totalSizeBytes,
        filesByType: filesByType,
      );
    } catch (e) {
      debugPrint('[ReceivedFilesService] Error getting stats: $e');
      return ReceivedFilesStats(
        totalFiles: 0,
        totalSizeBytes: 0,
        filesByType: {},
      );
    }
  }

  /// Nettoyer les fichiers reçus
  Future<void> clearReceivedFiles() async {
    try {
      final downloadsDir = StorageService().getDownloadsDir();
      if (downloadsDir.existsSync()) {
        for (final file in downloadsDir.listSync(recursive: true).whereType<File>()) {
          await file.delete();
        }
      }
      debugPrint('[ReceivedFilesService] Cleared all received files');
    } catch (e) {
      debugPrint('[ReceivedFilesService] Error clearing files: $e');
    }
  }
}

/// Stats des fichiers reçus
class ReceivedFilesStats {
  final int totalFiles;
  final int totalSizeBytes;
  final Map<String, List<File>> filesByType;

  ReceivedFilesStats({
    required this.totalFiles,
    required this.totalSizeBytes,
    required this.filesByType,
  });

  String get totalSizeFormatted {
    if (totalSizeBytes < 1024) return '$totalSizeBytes B';
    if (totalSizeBytes < 1024 * 1024) return '${(totalSizeBytes / 1024).toStringAsFixed(2)} KB';
    if (totalSizeBytes < 1024 * 1024 * 1024) {
      return '${(totalSizeBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(totalSizeBytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
