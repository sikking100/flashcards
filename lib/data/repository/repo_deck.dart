import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flashcards/data/firebase/firebase.dart';
import 'package:flashcards/data/models/model_deck.dart';

final repoDeckProvider = Provider<IRepoDeck>((ref) {
  final uid = ref.watch(sessionProvider);
  if (uid == null) throw Exception('User is not login yet');
  final store = ref.watch(firestoreProvider);
  return RepoDeck(store: store, uid: uid);
});

abstract class IRepoDeck {
  Future<QuerySnapshot<Map<String, dynamic>>> finds([DocumentSnapshot<Map<String, dynamic>>? lastDoc]);
  Future<DocumentSnapshot<Map<String, dynamic>>> find(String id);
  Future<void> update(String id, String title);
  Future<void> create(String title);
  Future<void> delete(String id);
}

class RepoDeck implements IRepoDeck {
  final String uid;
  final FirebaseFirestore store;

  RepoDeck({required this.uid, required this.store});

  CollectionReference<Map<String, dynamic>> get _ref => store.collection('users').doc(uid).collection('decks');

  @override
  Future<void> create(String title) {
    return _ref.add(ModelDeck.toNew(title).toMap());
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> find(String id) {
    return _ref.doc(id).get();
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> finds([DocumentSnapshot<Map<String, dynamic>>? lastDoc]) {
    Query<Map<String, dynamic>> query = _ref.orderBy('createdAt', descending: true).limit(10);
    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }
    return query.get();
  }

  @override
  Future<void> update(String id, String title) {
    return _ref.doc(id).update({'title': title});
  }

  @override
  Future<void> delete(String id) {
    return _ref.doc(id).delete();
  }
}
