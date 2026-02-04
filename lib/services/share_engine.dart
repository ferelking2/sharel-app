import 'dart:convert';
import 'dart:io';
import 'package:sharel_app/model/selected_item.dart';

class ShareEngine {
  HttpServer? _server;
  final List<SelectedItem> items;
  String sessionId = '';
  int port = 0;

  ShareEngine(this.items);

  Future<void> start() async {
    _server = await HttpServer.bind(InternetAddress.anyIPv4, 0);
    port = _server!.port;
    sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    _server!.listen(_handleRequest);
  }

  Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
  }

  Uri getLocalUri() {
    // Try to get local IPv4 address using a simple fallback
    try {
      // For now, fallback to loopback as listSync() is not available
      // In production, you'd need to use an async method or platform channels
      return Uri.parse('http://127.0.0.1:$port');
    } catch (e) {
      return Uri.parse('http://127.0.0.1:$port');
    }
  }

  void _handleRequest(HttpRequest req) async {
    final path = req.uri.path;
    if (path == '/session') {
      final meta = items.asMap().entries.map((e) {
        final item = e.value;
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
        };
      }).toList();
      req.response.headers.contentType = ContentType.json;
      req.response.write(jsonEncode({'sessionId': sessionId, 'items': meta}));
      await req.response.close();
      return;
    }

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
            req.response.statusCode = HttpStatus.notFound;
            await req.response.close();
            return;
          }
          final file = File(maybePath);
          if (!file.existsSync()) {
            req.response.statusCode = HttpStatus.notFound;
            await req.response.close();
            return;
          }
          req.response.headers.set(HttpHeaders.contentTypeHeader, 'application/octet-stream');
          req.response.headers.set(HttpHeaders.contentLengthHeader, file.lengthSync());
          await file.openRead().pipe(req.response);
          return;
        }
      }
    }

    req.response.statusCode = HttpStatus.notFound;
    await req.response.close();
  }
}
