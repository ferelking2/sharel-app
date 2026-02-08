import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sharel_app/l10n/app_localizations.dart';

class AppShell extends StatefulWidget {
  final Widget child;
  const AppShell({required this.child, super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  void _onNavDestinationSelected(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/files');
        break;
      case 2:
        context.go('/discovery');
        break;
      case 3:
        context.go('/me');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context);
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop && context.canPop()) {
          context.pop();
        }
      },
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.1))),
          ),
          child: NavigationBar(
            backgroundColor: theme.colorScheme.surface,
            elevation: 0,
            selectedIndex: _selectedIndex,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: t?.bottomNavHome ?? 'Accueil',
              ),
              NavigationDestination(
                icon: const Icon(Icons.folder_outlined),
                selectedIcon: const Icon(Icons.folder),
                label: t?.labelFiles ?? 'Fichiers',
              ),
              NavigationDestination(
                icon: const Icon(Icons.travel_explore),
                selectedIcon: const Icon(Icons.travel_explore),
                label: t?.bottomNavDiscovery ?? 'Découvrir',
              ),
              NavigationDestination(
                icon: const Icon(Icons.person_outline),
                selectedIcon: const Icon(Icons.person),
                label: t?.bottomNavMe ?? 'Profil',
              ),
            ],
            onDestinationSelected: _onNavDestinationSelected,
          ),
        ),
      ),
    );
  }
}
