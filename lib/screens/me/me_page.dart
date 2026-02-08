import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

class MePage extends StatelessWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            backgroundColor: theme.colorScheme.surface,
            elevation: 0,
            flexibleSpace: LayoutBuilder(builder: (context, constraints) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // Cover image
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/cover_placeholder.jpg'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.12), BlendMode.dstATop),
                        ),
                      ),
                    ),
                  ),
                  // Back button + actions
                  Positioned(
                    left: 8,
                    top: 12,
                    child: SafeArea(
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                  ),
                  // Avatar + name block overlapping
                  Positioned(
                    left: 16,
                    bottom: -40,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.surface,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 44,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, size: 40, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Prime Max',
                              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'ID: HFS2GW',
                              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Edit action
                  Positioned(
                    right: 16,
                    bottom: -20,
                    child: FloatingActionButton(
                      heroTag: 'edit_profile',
                      mini: true,
                      onPressed: () {},
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.edit),
                    ),
                  ),
                ],
              );
            }),
          ),

          // Body content
          SliverPadding(
            padding: const EdgeInsets.only(top: 56.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppTheme.spacing8),
                        Text('Compte', style: theme.textTheme.titleMedium?.copyWith(color: Colors.green, fontWeight: FontWeight.w700)),
                        const SizedBox(height: AppTheme.spacing12),

                        // Phone
                        Card(
                          elevation: 0,
                          shape: const RoundedRectangleBorder(side: BorderSide(color: Color(0xFFEDEFF2))),
                          child: ListTile(
                            leading: const CircleAvatar(child: Icon(Icons.phone)),
                            title: const Text('+242 065491040'),
                            subtitle: const Text('Numéro de téléphone'),
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacing8),

                        // Username
                        Card(
                          elevation: 0,
                          shape: const RoundedRectangleBorder(side: BorderSide(color: Color(0xFFEDEFF2))),
                          child: ListTile(
                            leading: const CircleAvatar(child: Icon(Icons.alternate_email)),
                            title: const Text('@sharel_user'),
                            subtitle: Text('Nom d\'utilisateur'),
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacing8),

                        // Bio
                        Card(
                          elevation: 0,
                          shape: const RoundedRectangleBorder(side: BorderSide(color: Color(0xFFEDEFF2))),
                          child: ListTile(
                            leading: const CircleAvatar(child: Icon(Icons.info_outline)),
                            title: const Text('Partagez vos fichiers rapidement'),
                            subtitle: Text('Bio'),
                          ),
                        ),

                        const SizedBox(height: AppTheme.spacing24),
                        Text('Paramètres', style: theme.textTheme.titleMedium?.copyWith(color: Colors.green, fontWeight: FontWeight.w700)),
                        const SizedBox(height: AppTheme.spacing12),

                        Card(
                          child: ListTile(
                            leading: CircleAvatar(backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.08), child: Icon(Icons.settings, color: theme.colorScheme.primary)),
                            title: Text('Général'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacing8),
                        Card(
                          child: ListTile(
                            leading: CircleAvatar(backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.08), child: Icon(Icons.tune, color: theme.colorScheme.primary)),
                            title: Text('Préférences'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacing8),
                        Card(
                          child: ListTile(
                            leading: CircleAvatar(backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.08), child: Icon(Icons.lock, color: theme.colorScheme.primary)),
                            title: Text('Confidentialité et sécurité'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {},
                          ),
                        ),

                        const SizedBox(height: AppTheme.spacing48),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
