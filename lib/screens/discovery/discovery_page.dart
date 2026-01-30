import 'package:flutter/material.dart';
import 'package:sharel_app/l10n/app_localizations.dart';

class DiscoveryPage extends StatelessWidget {
  const DiscoveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final mockDevices = [
      {'name': 'Mon iPhone', 'type': 'iOS'},
      {'name': 'PC Bureau', 'type': 'Windows'},
      {'name': 'Laptop', 'type': 'Linux'},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.labelReceive, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: mockDevices.length,
              separatorBuilder: (_, _) => const Divider(height: 8),
              itemBuilder: (context, index) {
                final d = mockDevices[index];
                return ListTile(
                  leading: const Icon(Icons.devices),
                  title: Text(d['name']!),
                  subtitle: Text(d['type']!),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // TODO: implémenter découverte / pairing
                    },
                    child: const Text('Connecter'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
