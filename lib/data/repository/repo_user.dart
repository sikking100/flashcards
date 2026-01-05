// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flashcards/data/models/model_user.dart';

abstract class IRepoUser {
  Future<ModelUser> get();
  Future<void> update({required String name, required String email});
  Future<void> boardingCompleted(bool value);
}

class RepoUser implements IRepoUser {
  final FirebaseAuth auth;
  final FirebaseFirestore store;

  RepoUser({required this.auth, required this.store});

  @override
  Future<void> boardingCompleted(bool value) {
    // TODO: implement boardingCompleted
    throw UnimplementedError();
  }

  @override
  Future<ModelUser> get() {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<void> update({required String name, required String email}) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
