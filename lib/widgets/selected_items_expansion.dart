import 'package:flutter/material.dart';
import '../model/selected_item.dart';
import '../core/theme/design_system.dart';

class SelectedItemsExpansion extends StatefulWidget {
  final Set<SelectedItem> items;
  final VoidCallback? onClear;

  const SelectedItemsExpansion({
    super.key,
    required this.items,
    this.onClear,
  });

  @override
  State<SelectedItemsExpansion> createState() => _SelectedItemsExpansionState();
}

class _SelectedItemsExpansionState extends State<SelectedItemsExpansion> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (widget.items.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.primary, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppTheme.spacing12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${widget.items.length} sélectionné(s)',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
            if (_isExpanded) ...[
              SizedBox(height: AppTheme.spacing12),
              Divider(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
              SizedBox(height: AppTheme.spacing12),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.items.toList()[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: AppTheme.spacing8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            _getItemIcon(item),
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          SizedBox(width: AppTheme.spacing8),
                          Expanded(
                            child: Text(
                              _getItemName(item),
                              style: theme.textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getItemIcon(SelectedItem item) {
      // ignore: unnecessary_underscores
      return item.when(
      contact: (_, __, ___) => Icons.person,
      file: (path, name, size) => Icons.insert_drive_file,
      video: (_, __, ___, ____) => Icons.video_library,
      photo: (_, __, ___) => Icons.image,
      music: (_, __, ___, ____, _____) => Icons.music_note,
      app: (_, __, ___) => Icons.apps,
    );
  }

  String _getItemName(SelectedItem item) {
    // ignore: unnecessary_underscores
    return item.when(
      contact: (_, name, __) => name,
      file: (path, name, size) => name,
      video: (_, __, title, ___) => title,
      photo: (_, __, ___) => 'Photo',
      music: (_, __, title, ___, ____) => title,
      app: (_, name, __) => name,
    );
  }
}
