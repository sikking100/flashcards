import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcards/data/firebase/firebase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final repoReviewProvider = Provider<IRepoReview>((ref) {
  final uid = ref.watch(sessionProvider);
  if (uid == null) throw Exception('User is not login yet');
  final store = ref.watch(firestoreProvider);
  return RepoReview(store: store, uid: uid);
});

abstract class IRepoReview {
  Future<QuerySnapshot<Map<String, dynamic>>> finds([DocumentSnapshot<Map<String, dynamic>>? lastDoc]);
  Future<QuerySnapshot<Map<String, dynamic>>> today();

  ///left, right, top, bottom
  Future<void> swipe({required String id, required String direction, required int inter, required int reps});
  Future<void> notknow({required String id, required int reviewCount});
}

class RepoReview implements IRepoReview {
  final FirebaseFirestore store;
  final String uid;

  RepoReview({required this.store, required this.uid});

  CollectionReference<Map<String, dynamic>> get _ref => store.collection('users').doc(uid).collection('reviews');

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> finds([DocumentSnapshot<Map<String, dynamic>>? lastDoc]) {
    Query<Map<String, dynamic>> query = _ref.where('reviewCount', isGreaterThan: 0).orderBy('reviewCount', descending: true).limit(10);
    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }
    return query.get();
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> today() {
    return _ref.where('nextReview', isLessThanOrEqualTo: DateTime.now().millisecondsSinceEpoch).get();
  }

  /// left, right, top, bottom
  @override
  Future<void> swipe({required String id, required String direction, required int inter, required int reps}) {
    final now = DateTime.now();
    int interval = 0;
    int nextReview = 0;
    if (direction == 'left') {
      interval = 0;
      nextReview = now.add(Duration(minutes: 10)).millisecondsSinceEpoch;
    }

    if (direction == 'right') {
      interval = 1;
      nextReview = now.add(Duration(days: interval)).millisecondsSinceEpoch;
      reps += 1;
    }

    if (direction == 'top') {
      if (inter == 0) {
        interval = 3;
      } else {
        interval = inter * 2;
      }
      reps += 1;
      nextReview = now.add(Duration(days: interval)).millisecondsSinceEpoch;
    }

    return _ref.doc(id).set({
      'nextReview': nextReview,
      'interval': interval,
      'lastReviewed': now.millisecondsSinceEpoch,
      'reps': reps,
    }, SetOptions(merge: true));
  }

  @override
  Future<void> notknow({required String id, required int reviewCount}) {
    final now = DateTime.now();
    reviewCount += 1;
    return _ref.doc(id).set({'lastReviewed': now.millisecondsSinceEpoch, 'reviewCount': reviewCount}, SetOptions(merge: true));
  }
}
