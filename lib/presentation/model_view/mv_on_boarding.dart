import 'package:flashcards/data/repository/repo_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mvMainBoardingActionProvider = Provider<MvOnBoardingAction>((ref) {
  return MvOnBoardingAction(ref);
});

class MvOnBoardingAction {
  final Ref ref;

  MvOnBoardingAction(this.ref);

  Future<void> completeOnBoarding() async {
    await ref.read(repoUserProvider).boardingCompleted(true);
  }
}
