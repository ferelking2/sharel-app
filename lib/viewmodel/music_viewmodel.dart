import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicState {
  final List<dynamic> songs;
  final bool isLoading;
  final String? error;

  MusicState({
    this.songs = const [],
    this.isLoading = false,
    this.error,
  });

  MusicState copyWith({
    List<dynamic>? songs,
    bool? isLoading,
    String? error,
  }) {
    return MusicState(
      songs: songs ?? this.songs,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class MusicViewModel extends StateNotifier<MusicState> {
  // final OnAudioQuery _audioQuery = OnAudioQuery();

  MusicViewModel() : super(MusicState()) {
    loadMusic();
  }

  Future<void> loadMusic() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      /*
      final permission = await Permission.audio.request();
      if (!permission.isGranted) {
        state = state.copyWith(
          isLoading: false,
          error: 'Permission denied',
        );
        return;
      }

      final songs = await _audioQuery.querySongs();
      state = state.copyWith(
        songs: songs,
        isLoading: false,
      );
      */
      state = state.copyWith(
        songs: [],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  List<dynamic> get filteredSongs {
    return state.songs;
  }
}

final musicProvider = StateNotifierProvider<MusicViewModel, MusicState>(
  (ref) => MusicViewModel(),
);