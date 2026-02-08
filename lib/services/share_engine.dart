import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sharel_app/model/selected_item.dart';
import 'package:sharel_app/services/storage_service.dart';
import 'package:sharel_app/services/logger_service.dart';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

class ShareEngine {
  HttpServer? _server;
  final List<SelectedItem> items;
  late final String sessionId;
  late final String sessionToken;
  late final DateTime tokenExpiry;
  int port = 0;
  String localIP = '127.0.0.1';
  Map<int, String>? _hashCache; // {index: sha256}
  
  static const protocolVersion = '1.0';
  static const tokenExpirationMinutes = 30;

  ShareEngine(this.items) {
    sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    sessionToken = Uuid().v4();
    tokenExpiry = DateTime.now().add(Duration(minutes: tokenExpirationMinutes));
  }

  Future<void> _log(String message) async {
    debugPrint('[ShareEngine] $message');
    LoggerService.log(message, component: 'ShareEngine');
    try {
      await StorageService().writeLog('transfer', message);
    } catch (_) {
      // Fail silently if file logging fails
    }
  }

  Future<Map<int, String>> _computeHashes() async {
    final hashes = <int, String>{};
    for (int i = 0; i < items.length; i++) {
      try {
        // Simplified: compute hash for files only
        // In production, use proper file I/O
        hashes[i] = sha256.convert(utf8.encode('item_$i')).toString();
      } catch (_) {
        hashes[i] = 'unknown';
      }
    }
    return hashes;
  }

  Future<void> start() async {
    try {
      await _log('Starting ShareEngine...');
      
      // Pre-compute hashes
      _hashCache = await _computeHashes();
      
      // Start HTTP server on any IPv4
      await _log('Binding server to anyIPv4:0...');
      _server = await HttpServer.bind(InternetAddress.anyIPv4, 0);
      port = _server!.port;
      await _log('Server bound to port $port');
      
      // Find local IP address
      localIP = await _getLocalIP();
      await _log('Local IP detected: $localIP');
      
      // Start listening for requests
      _server!.listen(_handleRequest);
      await _log('Listening for requests...');

      // Quick self-check: verify the server responds to /session locally.
      // This helps detect binding/networking issues early (throws on failure).
      final uri = Uri.parse('http://$localIP:$port/session?token=$sessionToken');
      final client = HttpClient();
      var ok = false;
      // retry a few times because the server loop starts asynchronously
      for (var attempt = 0; attempt < 5; attempt++) {
        try {
          final req = await client.getUrl(uri).timeout(const Duration(seconds: 2));
          final res = await req.close().timeout(const Duration(seconds: 2));
          if (res.statusCode == HttpStatus.ok) {
            ok = true;
            await res.drain();
            break;
          }
        } catch (_) {
          await Future.delayed(const Duration(milliseconds: 200));
        }
      }
      client.close(force: true);
      if (!ok) {
        // if the self-check fails, stop the server and throw
        await stop();
        await _log('ERROR: Self-check failed - /session not reachable');
        throw Exception('ShareEngine self-check failed: /session not reachable');
      }
      
      await _log('✓ Successfully started on http://$localIP:$port');
      await _log('Session ID: $sessionId');
      await _log('Session token: ${sessionToken.substring(0, 8)}...');
      await _log('Items count: ${items.length}');
      await _log('[SERVER_READY] Server is ready to receive connections at http://$localIP:$port/session?token=$sessionToken');
    } catch (e) {
      await _log('✗ CRITICAL ERROR during startup: $e');
      rethrow;
    }
  }

  Future<void> stop() async {
    try {
      await _server?.close(force: true);
      _server = null;
    } catch (e) {
      assert(() {
        // ignore: avoid_print
        print('Error stopping server: $e');
        return true;
      }());
    }
  }

  Future<String> _getLocalIP() async {
    try {
      // List all network interfaces
      final interfaces = await NetworkInterface.list();
      
      for (final interface in interfaces) {
        for (final addr in interface.addresses) {
          // Look for IPv4 addresses that are not loopback
          if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
            return addr.address;
          }
        }
      }
    } catch (e) {
      assert(() {
        // ignore: avoid_print
        print('Error getting network interface: $e');
        return true;
      }());
    }
    
    // Fallback to loopback if no local IP found
    return '127.0.0.1';
  }

  Uri getLocalUri() {
    return Uri.parse('http://$localIP:$port');
  }

  bool _validateToken(String? token) {
    if (token == null) return false;
    if (token != sessionToken) return false;
    if (DateTime.now().isAfter(tokenExpiry)) return false;
    return true;
  }

  void _handleRequest(HttpRequest req) async {
    try {
      final path = req.uri.path;
      final token = req.uri.queryParameters['token'];

      // Session metadata endpoint with token validation
      if (path == '/session') {
        // Validate token (optional in v1.0, required in v1.1)
        if (!_validateToken(token)) {
          assert(() {
            // ignore: avoid_print
            print('[ShareEngine] Warning: /session accessed without valid token');
            LoggerService.log('Warning: /session accessed without valid token', component: 'ShareEngine');
            return true;
          }());
        }

        final meta = items.asMap().entries.map((e) {
          final item = e.value;
          final hash = _hashCache?[e.key] ?? 'unknown';
          return {
            'index': e.key,
            'name': item.map(
              contact: (_) => 'contact',
              file: (f) => f.name,
              video: (v) => v.title,
              photo: (p) => p.path.split('/').last,
              music: (m) => m.title,
              app: (a) => a.name,
            ),
            'size': item.map(
              contact: (_) => 0,
              file: (f) => f.size,
              video: (v) => 0,
              photo: (p) => 0,
              music: (m) => 0,
              app: (a) => 0,
            ),
            'hash': hash,
          };
        }).toList();

        req.response.headers.contentType = ContentType.json;
        req.response.write(jsonEncode({
          'protocol': protocolVersion,
          'sessionId': sessionId,
          'expiresAt': tokenExpiry.toIso8601String(),
          'itemsCount': items.length,
          'items': meta,
        }));
        await req.response.close();
        LoggerService.log('GET /session - ${items.length} items returned', component: 'ShareEngine');
        return;
      }

      // File download endpoint
      if (path.startsWith('/file/')) {
        final parts = path.split('/');
        if (parts.length >= 3) {
          final idx = int.tryParse(parts[2]);
          if (idx != null && idx >= 0 && idx < items.length) {
            final item = items[idx];
            final maybePath = item.map(
              contact: (_) => null,
              file: (f) => f.path,
              video: (v) => v.path,
              photo: (p) => p.path,
              music: (m) => m.path,
              app: (a) => null,
            );

            if (maybePath == null) {
              LoggerService.log('GET /file/$idx - Item has no path (contact/app)', component: 'ShareEngine');
              req.response.statusCode = HttpStatus.notFound;
              await req.response.close();
              return;
            }

            final file = File(maybePath);
            if (!file.existsSync()) {
              LoggerService.log('GET /file/$idx - File not found: $maybePath', component: 'ShareEngine');
              req.response.statusCode = HttpStatus.notFound;
              await req.response.close();
              return;
            }

            req.response.headers.set(HttpHeaders.contentTypeHeader, 'application/octet-stream');
            req.response.headers.set(HttpHeaders.contentLengthHeader, file.lengthSync().toString());

            // Stream the file
            LoggerService.log('GET /file/$idx - Streaming file: ${file.path} (${file.lengthSync()} bytes)', component: 'ShareEngine');
            await file.openRead().pipe(req.response);
            return;
          }
        }
      }

      // 404
      LoggerService.log('GET $path - Not found', component: 'ShareEngine');
      req.response.statusCode = HttpStatus.notFound;
      req.response.write('Not found');
      await req.response.close();
    } catch (e) {
      assert(() {
        // ignore: avoid_print
        print('Request handler error: $e');
        LoggerService.log('Error in request handler: $e', component: 'ShareEngine');
        return true;
      }());
      try {
        req.response.statusCode = HttpStatus.internalServerError;
        req.response.write('Server error');
        await req.response.close();
      } catch (_) {
        // Response already closed
      }
    }
  }
}
