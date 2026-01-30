import 'package:flutter/material.dart';
import 'package:sharel_app/widgets/large_action_button.dart';
import 'package:sharel_app/l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.homeWelcome, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),

          // Large action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              LargeActionButton(
                icon: Icons.send,
                label: t.labelSend,
                onTap: () {
                  // TODO: Implémenter navigation vers l'écran Envoyer
                },
              ),
              LargeActionButton(
                icon: Icons.cloud_download,
                label: t.labelReceive,
                onTap: () {
                  // TODO: Implémenter navigation vers l'écran Recevoir
                },
              ),
              LargeActionButton(
                icon: Icons.folder,
                label: t.labelFiles,
                onTap: () {
                  // TODO: Ouvrir gestionnaire de fichiers
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Example card (Téléchargeur de vidéo)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TÉLÉCHARGEUR DE VIDÉO', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 72,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (_, i) => Container(
                              width: 96,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 6)],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.message, color: Theme.of(context).colorScheme.primary),
                                  const Spacer(),
                                  Text('WhatsApp', style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                            separatorBuilder: (_, _) => const SizedBox(width: 12),
                            itemCount: 4,
                          ),
                        )
                      ],
                    ),
                  ),
                  ElevatedButton(onPressed: () {}, child: const Text('PLUS'))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
