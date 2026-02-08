import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../viewmodel/media_viewmodel.dart';
import '../../../viewmodel/selection_viewmodel.dart';
import '../../../model/selected_item.dart';

class VideosTab extends StatefulWidget {
  const VideosTab({super.key});

  @override
  State<VideosTab> createState() => _VideosTabState();
}

class _VideosTabState extends State<VideosTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer(
      builder: (context, ref, child) {
        final videosState = ref.watch(videosProvider);
        final selection = ref.watch(selectionProvider);
        final selectionNotifier = ref.read(selectionProvider.notifier);

        if (videosState.isLoading && videosState.assets.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (videosState.error != null && videosState.assets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(videosState.error!),
                ElevatedButton(
                  onPressed: () => ref.read(videosProvider.notifier).loadVideos(),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          key: const PageStorageKey('videos'),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: videosState.assets.length + (videosState.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == videosState.assets.length) {
              ref.read(videosProvider.notifier).loadMore();
              return const Center(child: CircularProgressIndicator());
            }

            final asset = videosState.assets[index];
            final selectedItem = SelectedItem.video(
              id: asset.id,
              path: asset.relativePath ?? '',
              title: asset.title ?? '',
              duration: Duration(seconds: asset.duration),
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
                            : const Icon(Icons.video_file),
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