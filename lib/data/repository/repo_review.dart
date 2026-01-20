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
  Future<void> swipe({required String id, required String direction});
  Future<void> notknow({required String id});
  Future<void> update({required String id, required String front, required String back});
  Future<void> delete({required String id});
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
  Future<void> swipe({required String id, required String direction}) {
    final now = DateTime.now();

    if (direction == 'left') {
      return _ref.doc(id).set({
        'nextReview': now.add(Duration(minutes: 10)).millisecondsSinceEpoch,
        'interval': 0,
        'lastReviewed': now.millisecondsSinceEpoch,
        'reviewCount': FieldValue.increment(1),
      }, SetOptions(merge: true));
    }

    if (direction == 'right') {
      return _ref.doc(id).set({
        'nextReview': now.add(Duration(days: 1)).millisecondsSinceEpoch,
        'interval': 1,
        'lastReviewed': now.millisecondsSinceEpoch,
        'reps': FieldValue.increment(1),
      }, SetOptions(merge: true));
    }

    return store.runTransaction((transaction) async {
      final oldData = await transaction.get(_ref.doc(id));
      final oldInterval = oldData.data()?['interval'] as int? ?? 0;
      final oldReps = oldData.data()?['reps'] as int? ?? 0;
      final oldRevCount = oldData.data()?['reviewCount'] as int? ?? 0;
      int interval = 0;
      int nextReview = 0;
      int revCount = oldRevCount;
      int reps = oldReps;

      if (oldInterval == 0) {
        interval = 3;
      } else {
        interval = oldInterval * 2;
      }
      reps += 1;
      revCount = oldRevCount > 0 ? oldRevCount - 1 : 0;
      nextReview = now.add(Duration(days: interval)).millisecondsSinceEpoch;

      transaction.set(_ref.doc(id), {
        'nextReview': nextReview,
        'interval': interval,
        'lastReviewed': now.millisecondsSinceEpoch,
        'reps': reps,
        'reviewCount': revCount,
      }, SetOptions(merge: true));
    });
  }

  @override
  Future<void> notknow({required String id}) {
    final now = DateTime.now();
    return _ref.doc(id).set({'lastReviewed': now.millisecondsSinceEpoch, 'reviewCount': FieldValue.increment(1)}, SetOptions(merge: true));
  }

  @override
  Future<void> update({required String id, required String front, required String back}) {
    return _ref.doc(id).set({'front': front, 'back': back}, SetOptions(merge: true));
  }

  @override
  Future<void> delete({required String id}) {
    return _ref.doc(id).delete();
  }
}
