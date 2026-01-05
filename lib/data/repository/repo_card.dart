import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcards/data/models/model_review.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flashcards/data/firebase/firebase.dart';
import 'package:flashcards/data/models/model_card.dart';

final repoCardProvider = Provider<IRepoCard>((ref) {
  final uid = ref.watch(sessionProvider);
  if (uid == null) throw Exception('User is not login yet');
  final store = ref.watch(firestoreProvider);
  return RepoCard(store: store, uid: uid);
});

abstract class IRepoCard {
  Future<QuerySnapshot<Map<String, dynamic>>> finds({required String idDeck, DocumentSnapshot? lastDoc});
  Future<DocumentSnapshot<Map<String, dynamic>>> find({required String idDeck, required String id});
  Future<void> update({required String idDeck, required ModelCard card});
  Future<void> delete({required String idDeck, required String id});
  Future<void> create({required String idDeck, required String front, required String back});
  Future<void> bulk({required String idDeck, required List<ModelCard> list});
}

class RepoCard implements IRepoCard {
  final FirebaseFirestore store;
  final String uid;
  RepoCard({required this.store, required this.uid});

  CollectionReference<Map<String, dynamic>> get _ref => store.collection('users').doc(uid).collection('decks');

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> find({required String idDeck, required String id}) {
    return _ref.doc(idDeck).collection('cards').doc(id).get();
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> finds({required String idDeck, DocumentSnapshot<Object?>? lastDoc}) {
    Query<Map<String, dynamic>> query = _ref.doc(idDeck).collection('cards').orderBy('createdAt', descending: true).limit(10);
    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }
    return query.get();
  }

  @override
  Future<void> create({required String idDeck, required String front, required String back}) async {
    // buat card
    final response = await _ref.doc(idDeck).collection('cards').add(ModelCard.toNew(front: front, back: back).toMap());
    // buat review today
    return store.doc('users/$uid/reviews/${response.id}').set(ModelReview.toNew(id: response.id, idDeck: idDeck, front: front, back: back).toMap());
  }

  @override
  Future<void> delete({required String idDeck, required String id}) {
    return _ref.doc(idDeck).collection('cards').doc(id).delete();
  }

  @override
  Future<void> update({required String idDeck, required ModelCard card}) {
    return _ref.doc(idDeck).collection('cards').doc(card.id).set(card.toMap());
  }

  @override
  Future<void> bulk({required String idDeck, required List<ModelCard> list}) async {
    final batch = store.batch();
    final cardCollection = _ref.doc(idDeck).collection('cards');
    final reviewCollection = store.collection('users/$uid/reviews');

    for (final c in list) {
      final cardDoc = cardCollection.doc();
      final cardId = cardDoc.id;
      final reviewDoc = reviewCollection.doc(cardId);
      batch.set(cardDoc, c.toMap());
      batch.set(reviewDoc, ModelReview.toNew(id: cardId, idDeck: idDeck, front: c.front, back: c.back).toMap());
    }

    await batch.commit();
  }
}
