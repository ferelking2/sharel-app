import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../viewmodel/selection_viewmodel.dart';
import 'tabs/contacts_tab.dart';
import 'tabs/files_tab.dart';
import 'tabs/videos_tab.dart';
import 'tabs/apps_tab.dart';
import 'tabs/photos_tab.dart';
import 'tabs/music_tab.dart';

class SenderPage extends ConsumerStatefulWidget {
  const SenderPage({super.key});

  @override
  ConsumerState<SenderPage> createState() => _SenderPageState();
}

class _SenderPageState extends ConsumerState<SenderPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedCount = ref.watch(selectionProvider).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Envoyer', style: theme.textTheme.headlineMedium),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Contacts'),
            Tab(text: 'Fichiers'),
            Tab(text: 'Vidéos'),
            Tab(text: 'Applications'),
            Tab(text: 'Photos'),
            Tab(text: 'Musique'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ContactsTab(),
          FilesTab(),
          VideosTab(),
          AppsTab(),
          PhotosTab(),
          MusicTab(),
        ],
      ),
      bottomNavigationBar: selectedCount > 0
          ? BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$selectedCount sélectionné(s)'),
                  ElevatedButton(
                    onPressed: () {
                      // Naviguer vers l'écran de préparation du transfert
                      // la sélection est partagée via `selectionProvider`
                      context.go('/transfer/preparation');
                    },
                    child: const Text('Envoyer'),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}