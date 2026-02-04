import 'dart:io';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharel_app/services/share_engine.dart';
import 'package:sharel_app/model/selected_item.dart';

enum TransferStatus { idle, hosting, joining, receiving, completed, error }

class TransferState {
  final TransferStatus status;
  final double progress; // 0..1
  final String message;
  TransferState({required this.status, this.progress = 0.0, this.message = ''});

  TransferState copyWith({TransferStatus? status, double? progress, String? message}) {
    return TransferState(status: status ?? this.status, progress: progress ?? this.progress, message: message ?? this.message);
  }
}

class TransferViewModel extends StateNotifier<TransferState> {
  ShareEngine? _engine;
  TransferViewModel(): super(TransferState(status: TransferStatus.idle));

  Future<Uri?> startHost(Set<SelectedItem> selection) async {
    try {
      final items = selection.toList();
      _engine = ShareEngine(items);
      await _engine!.start();
      state = state.copyWith(status: TransferStatus.hosting, progress: 0.0, message: 'Host started');
      return _engine!.getLocalUri();
    } catch (e) {
      state = state.copyWith(status: TransferStatus.error, message: e.toString());
      return null;
    }
  }

  Future<void> stopHost() async {
    await _engine?.stop();
    _engine = null;
    state = state.copyWith(status: TransferStatus.idle, progress: 0.0, message: 'Stopped');
  }

  Future<void> joinAndDownload(String baseUrl, String saveDir) async {
    try {
      state = state.copyWith(status: TransferStatus.joining, progress: 0.0, message: 'Connecting');
      final uri = Uri.parse(baseUrl);
      final client = HttpClient();
      final resp = await client.getUrl(uri.replace(path: '/session')).then((r) => r.close());
      if (resp.statusCode != 200) {
        state = state.copyWith(status: TransferStatus.error, message: 'Session error ${resp.statusCode}');
        return;
      }
      final body = await resp.transform(utf8.decoder).join();
      final json = body.isNotEmpty ? jsonDecode(body) as Map : {};
      final items = (json['items'] as List<dynamic>).cast<Map<String, dynamic>>();
      final total = items.length;
      int received = 0;
      for (var it in items) {
        final idx = it['index'];
        final name = it['name'] ?? 'file_$idx';
        final outFile = File('$saveDir/$name');
        await outFile.create(recursive: true);
        final req = await client.getUrl(uri.replace(path: '/file/$idx'));
        final res = await req.close();
        final sink = outFile.openWrite();
        await res.pipe(sink);
        received++;
        state = state.copyWith(status: TransferStatus.receiving, progress: received / total, message: 'Receiving $received/$total');
      }
      state = state.copyWith(status: TransferStatus.completed, progress: 1.0, message: 'Done');
    } catch (e) {
      state = state.copyWith(status: TransferStatus.error, message: e.toString());
    }
  }
}

final transferProvider = StateNotifierProvider<TransferViewModel, TransferState>((ref) => TransferViewModel());

final targetServerProvider = StateProvider<String?>((ref) => null);
