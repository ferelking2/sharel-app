import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
          const SizedBox(height: 16),

          // Large action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              LargeActionButton(
                icon: FontAwesomeIcons.paperPlane,
                label: t.labelSend,
                onTap: () {
                  // TODO: Implémenter navigation vers l'écran Envoyer
                },
              ),
              LargeActionButton(
                icon: FontAwesomeIcons.arrowDown,
                label: t.labelReceive,
                onTap: () {
                  // TODO: Implémenter navigation vers l'écran Recevoir
                },
              ),
              LargeActionButton(
                icon: FontAwesomeIcons.solidFolder,
                label: t.labelFiles,
                onTap: () {
                  // TODO: Ouvrir gestionnaire de fichiers
                },
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
