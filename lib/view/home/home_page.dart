import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sharel_app/l10n/app_localizations.dart';
import '../../core/theme/design_system.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: _HomeHeader(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HomeMainActions(),
                const SizedBox(height: AppTheme.spacing32),
                _HomeQuickStats(),
                const SizedBox(height: AppTheme.spacing24),
                _HomeRecentTransfers(),
              ],
            ),
          ),
        ),
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
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.colorScheme.outline.withOpacity(0.1))),
      ),
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
              const SizedBox(width: AppTheme.spacing12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.share, color: theme.colorScheme.onPrimaryContainer, size: 20),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_none, color: theme.colorScheme.primary),
                onPressed: () => context.go('/notification'),
              ),
              IconButton(
                icon: Icon(Icons.person, color: theme.colorScheme.primary),
                onPressed: () => context.go('/me'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HomeMainActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context);
    if (t == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Actions principales', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.outline)),
        const SizedBox(height: AppTheme.spacing16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _ActionCard(
              icon: Icons.cloud_upload,
              label: t.labelSend,
              color: theme.colorScheme.primary,
              onTap: () => context.go('/sender'),
            ),
            _ActionCard(
              icon: Icons.cloud_download,
              label: t.labelReceive,
              color: theme.colorScheme.secondary,
              onTap: () => context.go('/receive/preparation'),
            ),
            _ActionCard(
              icon: Icons.folder,
              label: t.labelFiles,
              color: theme.colorScheme.tertiary,
              onTap: () => context.go('/files'),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 0,
          color: color.withOpacity(0.08),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(height: AppTheme.spacing12),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeQuickStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Statistiques', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.outline)),
        const SizedBox(height: AppTheme.spacing12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: '0',
                subtitle: 'Fichiers envoyés',
                icon: Icons.check_circle_outline,
              ),
            ),
            const SizedBox(width: AppTheme.spacing12),
            Expanded(
              child: _StatCard(
                title: '0',
                subtitle: 'Fichiers reçus',
                icon: Icons.download_done,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.primaryContainer.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 28),
            const SizedBox(width: AppTheme.spacing12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleLarge),
                Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeRecentTransfers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Transferts récents', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.outline)),
        const SizedBox(height: AppTheme.spacing12),
        Card(
          elevation: 0,
          color: theme.colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacing24),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.history, color: theme.colorScheme.outline.withOpacity(0.5), size: 48),
                  const SizedBox(height: AppTheme.spacing16),
                  Text(
                    'Aucun transfert récent',
                    style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.outline),
                  ),
                  Text(
                    'Vos transferts apparaîtront ici',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeBottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context);
    if (t == null) {
      return SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return NavigationBar(
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: t.bottomNavHome,
        ),
        NavigationDestination(
          icon: Icon(Icons.travel_explore),
          selectedIcon: Icon(Icons.travel_explore),
          label: t.bottomNavDiscovery,
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: t.bottomNavMe,
        ),
      ],
      selectedIndex: 0,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.go('/discovery');
            break;
          case 2:
            context.go('/me');
            break;
        }
      },
    );
  }
}
