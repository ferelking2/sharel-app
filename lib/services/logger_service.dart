import 'package:intl/intl.dart';

enum LogLevel { debug, info, warn, error }

class LogEntry {
  final DateTime timestamp;
  final String component; // 'ShareEngine', 'TransferVM', 'ClientUI'
  final String transferId;
  final String message;
  final LogLevel level;

  LogEntry({
    required this.timestamp,
    required this.component,
    required this.transferId,
    required this.message,
    required this.level,
  });

  String format() {
    final timeStr = DateFormat('HH:mm:ss.SSS').format(timestamp);
    final levelStr = level.name.toUpperCase();
    final tid = transferId.substring(0, 8);
    return '[$timeStr] [$component] [$tid] [$levelStr] $message';
  }
}

class LoggerService {
  static const int maxLines = 1000;
  static final List<LogEntry> logs = [];
  static String? _currentTransferId;

  static void setTransferId(String? id) => _currentTransferId = id;

  static void log(
    String message, {
    required String component,
    LogLevel level = LogLevel.info,
  }) {
    final entry = LogEntry(
      timestamp: DateTime.now(),
      component: component,
      transferId: _currentTransferId ?? 'no-transfer',
      message: message,
      level: level,
    );

    logs.add(entry);

    // Trim old entries
    if (logs.length > maxLines) {
      logs.removeRange(0, logs.length - maxLines);
    }

    // Debug console
    assert(() {
      // ignore: avoid_print
      print(entry.format());
      return true;
    }());
  }

  static String export() => logs.map((e) => e.format()).join('\n');

  static void clear() => logs.clear();

  static Map<String, dynamic> reportJson() {
    final tid = _currentTransferId ?? 'no-transfer';
    return {
      'transferId': tid,
      'timestamp': DateTime.now().toIso8601String(),
      'logEntries': logs.length,
      'logs': logs.map((e) => {
        'time': e.timestamp.toIso8601String(),
        'component': e.component,
        'level': e.level.name,
        'message': e.message,
      }).toList(),
    };
  }
}
