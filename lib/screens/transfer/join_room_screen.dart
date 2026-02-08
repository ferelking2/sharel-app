import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../viewmodel/transfer_viewmodel.dart';

class JoinRoomScreen extends ConsumerStatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  ConsumerState<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends ConsumerState<JoinRoomScreen> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Rejoindre une room'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              }
            },
          ),
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Collez l\'URL ou scannez le QR contenant l\'adresse du serveur (ex: http://192.168.1.5:4567)') ,
            TextField(controller: _ctrl, decoration: const InputDecoration(hintText: 'http://ip:port')),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                final val = _ctrl.text.trim();
                if (val.isNotEmpty) {
                  ref.read(targetServerProvider.notifier).state = val;
                  context.push('/transfer/client');
                }
              },
              child: const Text('Se connecter'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await context.push<String>('/transfer/scan');
                if (result != null && mounted) {
                  _ctrl.text = result;
                  ref.read(targetServerProvider.notifier).state = result;
                  if (mounted) {
                    // ignore: use_build_context_synchronously
                    context.push('/transfer/client');
                  }
                }
              },
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scanner QR'),
            ),
          ],
        ),
      ),
    );
  }
}
