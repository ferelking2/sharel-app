import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../viewmodel/music_viewmodel.dart';
class MusicTab extends StatefulWidget {
  const MusicTab({super.key});

  @override
  State<MusicTab> createState() => _MusicTabState();
}

class _MusicTabState extends State<MusicTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer(
      builder: (context, ref, child) {
        final musicState = ref.watch(musicProvider);

        if (musicState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (musicState.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(musicState.error!),
                ElevatedButton(
                  onPressed: () => ref.read(musicProvider.notifier).loadMusic(),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        return const Center(
          child: Text("Onglet Musique temporairement désactivé (compatibilité Android)"),
        );
      },
    );
  }
}