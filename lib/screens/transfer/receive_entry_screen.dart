import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReceiveEntryScreen extends StatelessWidget {
  const ReceiveEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recevoir')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => context.go('/transfer/host'),
              child: const Text('Créer une room (Host)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.go('/transfer/join'),
              child: const Text('Rejoindre via QR / URL'),
            ),
          ],
        ),
      ),
    );
  }
}
