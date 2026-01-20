import 'package:flashcards/data/firebase/firebase.dart';
import 'package:flashcards/data/models/model_user.dart';
import 'package:flashcards/data/repository/repo_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_logger/simple_logger.dart';

enum VIEW { onBoarding, home, loading, error }

final mainViewNotifierProvider = NotifierProvider<MainViewNotifier, VIEW>(MainViewNotifier.new);

class MainViewNotifier extends Notifier<VIEW> {
  @override
  VIEW build() {
    init();
    return VIEW.loading;
  }

  void init() async {
    try {
      SimpleLogger().info('rebuild');
      final user = ref.watch(sessionProvider);
      if (user == null) {
        await ref.read(firebaseAuthProvider).signInAnonymously();
        ref.invalidate(sessionProvider);
      }
      final response = await ref.read(repoUserProvider).get();
      final result = ModelUser.fromMap(response.data() ?? {});
      if (!result.onBoardingCompleted) {
        state = VIEW.onBoarding;
      } else {
        state = VIEW.home;
      }
      return;
    } catch (e) {
      SimpleLogger().info(e);
      state = VIEW.error;
    }
  }
}
