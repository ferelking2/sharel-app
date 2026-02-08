import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../viewmodel/selection_viewmodel.dart';
import '../../providers/role_provider.dart';
import '../../core/theme/design_system.dart';
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
      backgroundColor: AppColors.surfaceLight,
      appBar: _buildAppBar(context, theme),
      body: Column(
        children: [
          // Selection Summary Bar
          if (selectedCount > 0) _buildSelectionBar(context, selectedCount),

          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textGrey,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: 'Contacts'),
                Tab(text: 'Fichiers'),
                Tab(text: 'Vidéos'),
                Tab(text: 'Apps'),
                Tab(text: 'Photos'),
                Tab(text: 'Musique'),
              ],
            ),
          ),

          // Tab View
          Expanded(
            child: TabBarView(
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
          ),
        ],
      ),
      bottomNavigationBar: selectedCount > 0
          ? _buildBottomActionBar(context, selectedCount)
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: AppColors.textDark,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          }
        },
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sélectionner des fichiers',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded, color: AppColors.textDark),
          onPressed: () {},
        ),
      ],
      shadowColor: Colors.transparent,
    );
  }

  Widget _buildSelectionBar(BuildContext context, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(width: AppTheme.spacing12),
          Text(
            '$count élément${count > 1 ? 's' : ''} sélectionné${count > 1 ? 's' : ''}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              ref.read(selectionProvider.notifier).clear();
            },
            child: const Text('Effacer tout'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context, int selectedCount) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.of(context).viewPadding.bottom,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$selectedCount sélectionné${selectedCount > 1 ? 's' : ''}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              context.push('/transfer/preparation', extra: TransferRole.sender);
            },
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text('Suivant'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 2,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
