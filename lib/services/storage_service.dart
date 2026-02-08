import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

/// Service de gestion des chemins et structures de répertoires SHAREL
class StorageService {
  static final StorageService _instance = StorageService._internal();
  
  factory StorageService() {
    return _instance;
  }
  
  StorageService._internal();

  // Répertoire racine SHAREL
  late Directory _sharedir;
  
  // Sous-répertoires
  late Directory _cachedir;
  late Directory _dataDir;
  late Directory _mediaDir;
  late Directory _downloadsDir;
  late Directory _logsDir;

  bool _initialized = false;

  /// Initialiser la structure de répertoires SHAREL
  /// À appeler une seule fois au démarrage de l'appli
  Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      debugPrint('[StorageService] Initializing storage structure...');
      
      // Obtenir le répertoire de l'app (Android/data/com.sharel.app)
      final appDocDir = await getApplicationDocumentsDirectory();
      
      // Créer le dossier SHAREL à la racine de Documents
      _sharedir = Directory('${appDocDir.parent.path}/SHAREL');
      
      debugPrint('[StorageService] SHAREL root: ${_sharedir.path}');
      
      // Créer tous les répertoires
      await _createDirectories();
      
      _initialized = true;
      debugPrint('[StorageService] ✓ Storage initialized successfully');
    } catch (e) {
      debugPrint('[StorageService] ✗ Initialization error: $e');
      rethrow;
    }
  }

  Future<void> _createDirectories() async {
    try {
      // Répertoire racine
      if (!_sharedir.existsSync()) {
        await _sharedir.create(recursive: true);
        debugPrint('[StorageService] Created: ${_sharedir.path}');
      }

      // Android sous-dossiers
      _cachedir = Directory('${_sharedir.path}/Android/cache');
      _dataDir = Directory('${_sharedir.path}/Android/data');
      _mediaDir = Directory('${_sharedir.path}/Android/media');
      
      // Fichiers reçus
      _downloadsDir = Directory('${_sharedir.path}/Downloads');
      
      // Logs
      _logsDir = Directory('${_sharedir.path}/Logs');

      // Créer les répertoires Android
      for (final dir in [_cachedir, _dataDir, _mediaDir]) {
        if (!dir.existsSync()) {
          await dir.create(recursive: true);
          debugPrint('[StorageService] Created: ${dir.path}');
        }
      }

      // Créer les répertoires de contenu dans Media
      final mediaSubDirs = [
        'Photos',
        'Videos',
        'Audio',
        'Documents',
        'Apps',
        'Archives',
      ];

      for (final subDir in mediaSubDirs) {
        final dir = Directory('${_mediaDir.path}/$subDir');
        if (!dir.existsSync()) {
          await dir.create(recursive: true);
          debugPrint('[StorageService] Created: ${dir.path}');
        }
      }

      // Créer les répertoires de transfert dans Downloads
      final downloadSubDirs = [
        'Received_Photos',
        'Received_Videos',
        'Received_Audio',
        'Received_Documents',
        'Received_Apps',
        'Received_Other',
      ];

      for (final subDir in downloadSubDirs) {
        final dir = Directory('${_downloadsDir.path}/$subDir');
        if (!dir.existsSync()) {
          await dir.create(recursive: true);
          debugPrint('[StorageService] Created: ${dir.path}');
        }
      }

      // Créer le dossier Logs
      if (!_logsDir.existsSync()) {
        await _logsDir.create(recursive: true);
        debugPrint('[StorageService] Created: ${_logsDir.path}');
      }
    } catch (e) {
      debugPrint('[StorageService] Error creating directories: $e');
      rethrow;
    }
  }

  /// Obtenir le répertoire racine SHAREL
  Directory getSharelsRoot() {
    if (!_initialized) {
      throw StateError('StorageService not initialized. Call initialize() first.');
    }
    return _sharedir;
  }

  /// Obtenir le répertoire de cache
  Directory getCacheDir() {
    if (!_initialized) {
      throw StateError('StorageService not initialized.');
    }
    return _cachedir;
  }

  /// Obtenir le répertoire de data
  Directory getDataDir() {
    if (!_initialized) {
      throw StateError('StorageService not initialized.');
    }
    return _dataDir;
  }

  /// Obtenir le répertoire media
  Directory getMediaDir() {
    if (!_initialized) {
      throw StateError('StorageService not initialized.');
    }
    return _mediaDir;
  }

  /// Obtenir le répertoire des downloads/fichiers reçus
  Directory getDownloadsDir() {
    if (!_initialized) {
      throw StateError('StorageService not initialized.');
    }
    return _downloadsDir;
  }

  /// Obtenir le répertoire des logs
  Directory getLogsDir() {
    if (!_initialized) {
      throw StateError('StorageService not initialized.');
    }
    return _logsDir;
  }

  /// Obtenir le chemin correct pour un type de fichier reçu
  Directory getReceivedItemDir(String mediaType) {
    final downloadDir = getDownloadsDir();
    
    late String subDir;
    switch (mediaType.toLowerCase()) {
      case 'photo':
      case 'image':
      case 'jpg':
      case 'png':
      case 'gif':
      case 'webp':
        subDir = 'Received_Photos';
        break;
      case 'video':
      case 'mp4':
      case 'mkv':
      case 'avi':
      case 'mov':
        subDir = 'Received_Videos';
        break;
      case 'audio':
      case 'music':
      case 'mp3':
      case 'wav':
      case 'm4a':
        subDir = 'Received_Audio';
        break;
      case 'document':
      case 'pdf':
      case 'doc':
      case 'docx':
      case 'xls':
      case 'xlsx':
      case 'ppt':
      case 'txt':
        subDir = 'Received_Documents';
        break;
      case 'app':
      case 'apk':
        subDir = 'Received_Apps';
        break;
      default:
        subDir = 'Received_Other';
    }
    
    return Directory('${downloadDir.path}/$subDir');
  }

  /// Obtenir le chemin pour stocker un fichier média local
  Directory getMediaSubDir(String mediaType) {
    final mediaDir = getMediaDir();
    
    late String subDir;
    switch (mediaType.toLowerCase()) {
      case 'photo':
      case 'image':
        subDir = 'Photos';
        break;
      case 'video':
        subDir = 'Videos';
        break;
      case 'audio':
      case 'music':
        subDir = 'Audio';
        break;
      case 'document':
        subDir = 'Documents';
        break;
      case 'app':
        subDir = 'Apps';
        break;
      default:
        subDir = 'Archives';
    }
    
    return Directory('${mediaDir.path}/$subDir');
  }

  /// Crée et retourne un fichier log avec timestamp
  Future<File> createLogFile(String tag) async {
    try {
      final logsDir = getLogsDir();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.')[0];
      final logFile = File('${logsDir.path}/sharel_${tag}_$timestamp.log');
      
      if (!logFile.existsSync()) {
        await logFile.create(recursive: true);
      }
      
      return logFile;
    } catch (e) {
      debugPrint('[StorageService] Error creating log file: $e');
      rethrow;
    }
  }

  /// Écrire dans un fichier log
  Future<void> writeLog(String tag, String message) async {
    try {
      final logsDir = getLogsDir();
      final today = DateTime.now().toIso8601String().split('T')[0];
      final logFile = File('${logsDir.path}/sharel_${tag}_$today.log');
      
      final timestamp = DateTime.now().toIso8601String();
      final logLine = '[$timestamp] $message\n';
      
      if (!logFile.existsSync()) {
        await logFile.create(recursive: true);
      }
      
      await logFile.writeAsString(logLine, mode: FileMode.append);
    } catch (e) {
      debugPrint('[StorageService] Error writing log: $e');
    }
  }

  /// Obtenir les statistiques de stockage
  Future<StorageStats> getStorageStats() async {
    try {
      final root = getSharelsRoot();
      int totalSize = 0;
      int filesCount = 0;

      if (root.existsSync()) {
        final files = root.listSync(recursive: true);
        for (final file in files) {
          if (file is File) {
            totalSize += file.lengthSync();
            filesCount++;
          }
        }
      }

      return StorageStats(
        totalSizeBytes: totalSize,
        filesCount: filesCount,
        sharelsRootPath: root.path,
      );
    } catch (e) {
      debugPrint('[StorageService] Error getting storage stats: $e');
      return StorageStats(totalSizeBytes: 0, filesCount: 0, sharelsRootPath: '');
    }
  }

  /// Nettoyer les fichiers temporaires du cache
  Future<void> clearCache() async {
    try {
      final cacheDir = getCacheDir();
      if (cacheDir.existsSync()) {
        cacheDir.deleteSync(recursive: true);
        await cacheDir.create(recursive: true);
        debugPrint('[StorageService] Cache cleared');
      }
    } catch (e) {
      debugPrint('[StorageService] Error clearing cache: $e');
    }
  }
}

/// Modèle pour les statistiques de stockage
class StorageStats {
  final int totalSizeBytes;
  final int filesCount;
  final String sharelsRootPath;

  StorageStats({
    required this.totalSizeBytes,
    required this.filesCount,
    required this.sharelsRootPath,
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
