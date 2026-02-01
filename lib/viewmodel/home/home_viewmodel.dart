import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/home_state.dart';

final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>((ref) => HomeViewModel());

class HomeViewModel extends StateNotifier<HomeState> {
  HomeViewModel() : super(const HomeState());
  // TODO: Ajouter logique de chargement, actions, etc.
}
