import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../viewmodel/transfer_viewmodel.dart';

class RoomClientScreen extends ConsumerStatefulWidget {
  const RoomClientScreen({super.key});

  @override
  ConsumerState<RoomClientScreen> createState() => _RoomClientScreenState();
}

class _RoomClientScreenState extends ConsumerState<RoomClientScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final target = ref.read(targetServerProvider);
      if (target == null) {
        return;
      }
      final dir = await getApplicationDocumentsDirectory();
      await ref.read(transferProvider.notifier).joinAndDownload(target, dir.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transferProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Room (Client)')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Status: ${state.message}'),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: state.progress),
          ],
        ),
      ),
    );
  }
}
