import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../viewmodel/media_viewmodel.dart';
import '../../../viewmodel/selection_viewmodel.dart';
import '../../../model/selected_item.dart';

class PhotosTab extends StatefulWidget {
  const PhotosTab({super.key});

  @override
  State<PhotosTab> createState() => _PhotosTabState();
}

class _PhotosTabState extends State<PhotosTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer(
      builder: (context, ref, child) {
        final photosState = ref.watch(photosProvider);
        final selection = ref.watch(selectionProvider);
        final selectionNotifier = ref.read(selectionProvider.notifier);

        if (photosState.isLoading && photosState.assets.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (photosState.error != null && photosState.assets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(photosState.error!),
                ElevatedButton(
                  onPressed: () => ref.read(photosProvider.notifier).loadPhotos(),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          key: const PageStorageKey('photos'),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: photosState.assets.length + (photosState.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == photosState.assets.length) {
              ref.read(photosProvider.notifier).loadMore();
              return const Center(child: CircularProgressIndicator());
            }

            final asset = photosState.assets[index];
            final selectedItem = SelectedItem.photo(
              id: asset.id,
              path: asset.relativePath ?? '',
              date: asset.createDateTime,
            );
            final isSelected = selection.contains(selectedItem);

            return FutureBuilder<Uint8List?>(
              future: asset.thumbnailData,
              builder: (context, snapshot) {
                final thumbnail = snapshot.data;
                return GestureDetector(
                  onTap: () {
                    selectionNotifier.toggle(selectedItem);
                  },
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.grey,
                        child: thumbnail != null
                            ? Image.memory(thumbnail, fit: BoxFit.cover)
                            : const Icon(Icons.image),
                      ),
                      if (isSelected)
                        const Positioned(
                          top: 4,
                          right: 4,
                          child: Icon(Icons.check_circle, color: Colors.blue),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}