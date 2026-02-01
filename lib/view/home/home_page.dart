import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/design_system.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: _HomeHeader(),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HomeSearchBar(),
                  const SizedBox(height: AppTheme.spacing24),
                  _HomeMainActions(),
                  const SizedBox(height: AppTheme.spacing24),
                  _HomeVideoDownloaderCard(),
                  const SizedBox(height: AppTheme.spacing16),
                  _HomeCleanerCard(),
                  const SizedBox(height: AppTheme.spacing16),
                  _HomeMusicCard(),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _HomeBottomNav(),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16, vertical: AppTheme.spacing12),
      color: theme.colorScheme.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'SHAREL',
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: AppTheme.spacing8),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.whatsapp, color: theme.colorScheme.primary, size: 28),
              const SizedBox(width: AppTheme.spacing16),
              Icon(Icons.notifications_none, color: theme.colorScheme.primary, size: 28),
              const SizedBox(width: AppTheme.spacing16),
              Icon(Icons.add_circle_outline, color: theme.colorScheme.primary, size: 28),
            ],
          ),
        ],
      ),
    );
  }
}

class _HomeSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      decoration: InputDecoration(
        hintText: 'Rechercher...',
        prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
        filled: true,
        fillColor: theme.colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: AppTheme.spacing12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radius),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _HomeMainActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _CircleActionButton(
          icon: Icons.send,
          label: 'Envoyer',
          color: theme.colorScheme.primary,
        ),
        _CircleActionButton(
          icon: Icons.download,
          label: 'Recevoir',
          color: theme.colorScheme.primary,
        ),
        _CircleActionButton(
          icon: Icons.folder,
          label: 'Fichiers',
          color: theme.colorScheme.primary,
        ),
      ],
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _CircleActionButton({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: color,
          shape: const CircleBorder(),
          elevation: AppTheme.elevation,
          child: InkWell(
            borderRadius: BorderRadius.circular(40),
            onTap: () {},
            child: SizedBox(
              width: 72,
              height: 72,
              child: Icon(icon, color: Colors.white, size: 36),
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(label, style: Theme.of(context).textTheme.labelLarge),
      ],
    );
  }
}

class _HomeVideoDownloaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('TÉLÉCHARGEUR DE VIDÉO', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppTheme.spacing12),
            Row(
              children: [
                _AppIconButton(icon: Icons.whatsapp, label: 'WhatsApp'),
                _AppIconButton(icon: Icons.camera_alt, label: 'Instagram'),
                _AppIconButton(icon: Icons.facebook, label: 'Facebook'),
                _AppIconButton(icon: Icons.tv, label: 'FB Watch'),
                const Spacer(),
                TextButton(onPressed: () {}, child: const Text('PLUS')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AppIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _AppIconButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppTheme.spacing12),
      child: Column(
        children: [
          Material(
            color: Theme.of(context).colorScheme.secondary,
            shape: const CircleBorder(),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(icon, color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _HomeCleanerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Row(
          children: [
            CircularProgressIndicator(
              value: 0.96,
              color: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.surface,
            ),
            const SizedBox(width: AppTheme.spacing16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('624KB nettoyés', style: theme.textTheme.titleLarge),
                Text('50.51GB utilisés', style: theme.textTheme.bodyMedium),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: const Text('NETTOYER'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeMusicCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.music_note, color: theme.colorScheme.primary, size: 32),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: Text(
                    "J'ai trouvé 122 de chansons que vous pouvez écouter en",
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _MusicActionButton(icon: Icons.download_done, label: 'Reçu'),
                _MusicActionButton(icon: Icons.add, label: 'Ajouté'),
                _MusicActionButton(icon: Icons.favorite, label: 'Favori'),
                _MusicActionButton(icon: Icons.playlist_play, label: 'Liste de lecture'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MusicActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MusicActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Theme.of(context).colorScheme.primary,
          shape: const CircleBorder(),
          child: SizedBox(
            width: 36,
            height: 36,
            child: Icon(icon, color: Colors.white, size: 18),
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _HomeBottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return NavigationBar(
      backgroundColor: theme.colorScheme.background,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home),
          label: 'Accueil',
        ),
        NavigationDestination(
          icon: Icon(Icons.travel_explore),
          label: 'Découvrir',
        ),
        NavigationDestination(
          icon: Icon(Icons.person),
          label: 'Moi',
        ),
      ],
      selectedIndex: 0,
      onDestinationSelected: (index) {},
    );
  }
}
