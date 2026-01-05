import 'package:flashcards/data/repository/repo_review.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mvStudyProvider = Provider<MvStudy>((ref) {
  return MvStudy(ref: ref);
});

class MvStudy {
  final Ref ref;
  MvStudy({required this.ref});
  Future<void> swipe({required String id, required String direction, required int reps, required int inter}) {
    return ref.read(repoReviewProvider).swipe(id: id, direction: direction, inter: inter, reps: reps);
  }

  Future<void> notknow({required String id, required int reviewCount}) {
    return ref.read(repoReviewProvider).notknow(id: id, reviewCount: reviewCount);
  }
}
