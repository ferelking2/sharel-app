import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../viewmodel/selection_viewmodel.dart';
import '../../providers/permission_provider.dart';
import '../../providers/role_provider.dart';
import '../../core/theme/design_system.dart';
import '../../services/permission_service.dart';
import '../../services/share_engine.dart';
import '../../model/selected_item.dart';

class PreparationScreen extends ConsumerWidget {
  final TransferRole role;

  const PreparationScreen({
    super.key,
    required this.role,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(selectionProvider);
    final perms = ref.watch(requiredPermissionsProvider);
    
    if (selection.isEmpty) {
      return PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            debugPrint('[PreparationScreen] Popped - no items selected');
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Préparation'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          body: const Center(
            child: Text('Aucun élément sélectionné'),
          ),
        ),
      );
    }
    
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          debugPrint('[PreparationScreen] Popped - returning to previous screen');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Prérequis de transfert'),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: perms.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) {
            debugPrint('[PreparationScreen] Error: $err');
            return Center(child: Text('Erreur: $err'));
          },
          data: (permissions) => _buildContent(
            context,
            selection,
            permissions,
            ref,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    Set<SelectedItem> selection,
    Map<String, PermissionStatus> permissions,
    WidgetRef ref,
  ) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;
    final allGranted = permissions.values.every((s) => s.isGranted);

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? AppTheme.spacing16 : AppTheme.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Autorisations requises',
            style: theme.textTheme.headlineSmall,
          ),
          SizedBox(height: AppTheme.spacing16),
          ...permissions.entries.map((e) => Padding(
            padding: EdgeInsets.only(bottom: AppTheme.spacing12),
            child: _PermissionItem(
              title: e.key,
              isGranted: e.value.isGranted,
              isDenied: e.value.isDenied,
              isPermanentlyDenied: e.value.isPermanentlyDenied,
              permissionKey: e.key,
            ),
          )),
          SizedBox(height: AppTheme.spacing32),
          Container(
            padding: EdgeInsets.all(AppTheme.spacing16),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info,
                  color: theme.colorScheme.secondary,
                  size: 20,
                ),
                SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: Text(
                    '${selection.length} élément(s) sélectionné(s)',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppTheme.spacing20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: allGranted
                  ? () => _startTransfer(context, selection, ref)
                  : null,
              icon: const Icon(Icons.cloud_upload),
              label: const Text('Créer une room'),
            ),
          ),
          if (!allGranted) ...[
            SizedBox(height: AppTheme.spacing12),
            Text(
              'Veuillez accepter toutes les autorisations pour continuer',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _startTransfer(
    BuildContext context,
    Set<SelectedItem> selection,
    WidgetRef ref,
  ) async {
    try {
      debugPrint('[PreparationScreen] Starting transfer with ${selection.length} items');
      
      // Convert Set to List for ShareEngine
      final items = selection.toList();
      
      // Create and start ShareEngine
      final engine = ShareEngine(items);
      await engine.start();
      
      debugPrint('[PreparationScreen] ShareEngine started successfully on port ${engine.port}');
      
      if (!context.mounted) return;
      context.go('/transfer/host');
    } catch (e) {
      debugPrint('[PreparationScreen] Error starting transfer: $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class _PermissionItem extends ConsumerWidget {
  final String title;
  final bool isGranted;
  final bool isDenied;
  final bool isPermanentlyDenied;
  final String permissionKey;

  const _PermissionItem({
    required this.title,
    required this.isGranted,
    required this.isDenied,
    required this.isPermanentlyDenied,
    required this.permissionKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final statusColor = isGranted ? Colors.green : Colors.orange;
    final statusIcon = isGranted ? Icons.check_circle : Icons.info;
    final statusText = isGranted ? 'Accordée' : 'À accepter';
    final label = PermissionService.getPermissionLabel(title);

    return GestureDetector(
      onTap: isGranted ? null : () => _requestPermission(context, ref),
      child: Container(
        padding: EdgeInsets.all(AppTheme.spacing12),
        decoration: BoxDecoration(
          border: Border.all(
            color: statusColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
          color: statusColor.withValues(alpha: 0.05),
        ),
        child: Row(
          children: [
            Icon(statusIcon, color: statusColor, size: 24),
            SizedBox(width: AppTheme.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (!isGranted)
                    Padding(
                      padding: EdgeInsets.only(top: AppTheme.spacing8),
                      child: Text(
                        isPermanentlyDenied
                            ? 'Tapez pour activer dans les paramètres'
                            : 'Tapez pour accepter',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: statusColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Text(
              statusText,
              style: theme.textTheme.bodySmall?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestPermission(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      debugPrint('[_PermissionItem] Requesting permission: $title');
      final label = PermissionService.getPermissionLabel(title);
      
      PermissionStatus status;
      switch (permissionKey) {
        case 'Photos':
        case 'Storage':
        case 'Manage External Storage':
          status = await PermissionService.requestStoragePermission();
          break;
        case 'Camera':
          status = await PermissionService.requestCameraPermission();
          break;
        case 'Nearby Wifi Devices':
          status = await PermissionService.requestNearbyWifiPermission();
          break;
        default:
          status = PermissionStatus.denied;
      }

      debugPrint('[_PermissionItem] Permission result: $status');

      if (status.isDenied) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label refusée. Veuillez réessayer.'),
            duration: const Duration(seconds: 2),
          ),
        );
      } else if (status.isPermanentlyDenied) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label refusée définitivement. Ouvrir les paramètres?'),
            action: SnackBarAction(
              label: 'Paramètres',
              onPressed: () async {
                await openAppSettings();
              },
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      } else if (status.isGranted) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label acceptée'),
            duration: const Duration(seconds: 2),
          ),
        );
        // Refresh permissions state
        ref.refresh(requiredPermissionsProvider);
      }
    } catch (e) {
      debugPrint('[_PermissionItem] Error requesting permission: $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
