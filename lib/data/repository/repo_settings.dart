import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcards/data/models/model_settings.dart';

abstract class IRepoSettings {
  Future<void> changeSettings(ModelSettings settings);
}

class RepoSettings implements IRepoSettings {
  final FirebaseFirestore store;
  final FirebaseAuth auth;

  RepoSettings(this.store, this.auth);
  @override
  Future<void> changeSettings(ModelSettings settings) {
    // TODO: implement changeSettings
    throw UnimplementedError();
  }
}
