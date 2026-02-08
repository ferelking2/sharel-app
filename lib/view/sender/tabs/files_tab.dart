import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../viewmodel/files_viewmodel.dart';
import '../../../viewmodel/selection_viewmodel.dart';
import '../../../model/selected_item.dart';

class FilesTab extends StatefulWidget {
  const FilesTab({super.key});

  @override
  State<FilesTab> createState() => _FilesTabState();
}

class _FilesTabState extends State<FilesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer(
      builder: (context, ref, child) {
        final filesState = ref.watch(filesProvider);
        final selection = ref.watch(selectionProvider);
        final selectionNotifier = ref.read(selectionProvider.notifier);

        return Column(
          children: [
            ElevatedButton(
              onPressed: () => ref.read(filesProvider.notifier).pickFiles(),
              child: const Text('Sélectionner des fichiers'),
            ),
            Expanded(
              child: ListView.builder(
                key: const PageStorageKey('files'),
                itemCount: filesState.files.length,
                itemBuilder: (context, index) {
                  final file = filesState.files[index];
                  final selectedItem = SelectedItem.file(
                    path: file.path!,
                    name: file.name,
                    size: file.size,
                  );
                  final isSelected = selection.contains(selectedItem);

                  return ListTile(
                    leading: const Icon(Icons.insert_drive_file),
                    title: Text(file.name),
                    subtitle: Text('${file.size} bytes'),
                    trailing: Checkbox(
                      value: isSelected,
                      onChanged: (value) {
                        selectionNotifier.toggle(selectedItem);
                      },
                    ),
                    onTap: () {
                      selectionNotifier.toggle(selectedItem);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}