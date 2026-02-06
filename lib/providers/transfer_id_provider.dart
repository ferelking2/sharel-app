import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final transferIdProvider = StateProvider<String?>((ref) {
  return null; // null until transfer starts
});

final newTransferIdProvider = Provider<String>((ref) {
  // Generate a new unique transfer ID
  return const Uuid().v4();
});
