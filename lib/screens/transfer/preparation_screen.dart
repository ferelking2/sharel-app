import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../viewmodel/selection_viewmodel.dart';

class PreparationScreen extends ConsumerWidget {
  const PreparationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(selectionProvider);
    if (selection.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Préparation')),
        body: const Center(child: Text('Aucun élément sélectionné')),
      );
    }
    final isIOS = Platform.isIOS;
    
    return Scaffold(
      appBar: AppBar(title: const Text('Préparation du transfert')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Prérequis de transfert', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 20),
              _PrerequisItem(
                icon: Icons.wifi,
                title: 'WiFi',
                description: 'Assurez-vous que le WiFi est activé et connecté',
                status: '✓ Activé',
              ),
              const SizedBox(height: 12),
              _PrerequisItem(
                icon: Icons.location_on,
                title: 'Réseau local',
                description: 'Permission d\'accès au réseau local',
                status: '✓ Accordée',
              ),
              const SizedBox(height: 12),
              _PrerequisItem(
                icon: Icons.storage,
                title: 'Stockage',
                description: 'Permission d\'accès au stockage',
                status: '✓ Accordée',
              ),
              if (isIOS) ...[
                const SizedBox(height: 12),
                _PrerequisItem(
                  icon: Icons.info,
                  title: 'Mode iOS',
                  description: 'Sur iOS, vous pouvez être client (rejoindre un host)',
                  status: '⚠ Info',
                ),
              ],
              const SizedBox(height: 32),
              Text('${selection.length} élément(s) sélectionné(s)', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 20),
              Text('Choisissez votre rôle :', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/transfer/host'),
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text('Créer une room (Host)'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/transfer/join'),
                  icon: const Icon(Icons.input),
                  label: const Text('Rejoindre (Client)'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrerequisItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String status;
  
  const _PrerequisItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyLarge),
                  Text(description, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Text(status, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
