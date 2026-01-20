// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcards/data/firebase/firebase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final repoUserProvider = Provider<IRepoUser>((ref) {
  final uid = ref.watch(sessionProvider);
  if (uid == null) throw Exception('User is not login yet');
  final store = ref.watch(firestoreProvider);
  return RepoUser(store: store, uid: uid);
});

abstract class IRepoUser {
  Future<DocumentSnapshot<Map<String, dynamic>>> get();
  Future<void> update({required String name, required String email});
  Future<void> boardingCompleted(bool value);
}

class RepoUser implements IRepoUser {
  final String uid;
  final FirebaseFirestore store;

  RepoUser({required this.uid, required this.store});

  DocumentReference<Map<String, dynamic>> get _ref => store.collection('users').doc(uid);

  @override
  Future<void> boardingCompleted(bool value) {
    return _ref.set({'onBoardingCompleted': value}, SetOptions(merge: true));
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> get() {
    return _ref.get();
  }

  @override
  Future<void> update({required String name, required String email}) {
    return _ref.set({'name': name, 'email': email}, SetOptions(merge: true));
  }
}
