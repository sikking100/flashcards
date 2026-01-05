import 'package:flashcards/data/firebase/firebase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_logger/simple_logger.dart';

final mainProvider = FutureProvider.autoDispose<void>((ref) async {
  try {
    SimpleLogger().info('rebuild');
    final user = ref.watch(sessionProvider);
    if (user == null) {
      await ref.read(firebaseAuthProvider).signInAnonymously();
      ref.invalidate(sessionProvider);
    }
    return;
  } catch (e) {
    rethrow;
  }
});
