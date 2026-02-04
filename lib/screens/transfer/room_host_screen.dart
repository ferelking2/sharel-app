import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodel/selection_viewmodel.dart';
import '../../viewmodel/transfer_viewmodel.dart';

class RoomHostScreen extends ConsumerStatefulWidget {
  const RoomHostScreen({super.key});

  @override
  ConsumerState<RoomHostScreen> createState() => _RoomHostScreenState();
}

class _RoomHostScreenState extends ConsumerState<RoomHostScreen> {
  Uri? _uri;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final selection = ref.read(selectionProvider);
      final uri = await ref.read(transferProvider.notifier).startHost(selection);
      setState(() {
        _uri = uri;
      });
    });
  }

  @override
  void dispose() {
    ref.read(transferProvider.notifier).stopHost();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transferProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Room (Host)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_uri == null)
              const CircularProgressIndicator()
            else ...[
              Text('Serveur démarré ✓', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              SelectableText(
                _uri!.toString(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Text('Partagez cette adresse avec le client', style: Theme.of(context).textTheme.bodySmall),
            ],
            const SizedBox(height: 16),
            Text('Status: ${state.message}'),
          ],
        ),
      ),
    );
  }
}
