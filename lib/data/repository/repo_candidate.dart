import 'dart:convert';

import 'package:flashcards/data/firebase/firebase.dart';
import 'package:flashcards/data/models/model_candidate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:simple_logger/simple_logger.dart';

final repoCandidateProvider = Provider<IRepoCandidate>((ref) {
  final uid = ref.watch(sessionProvider);
  if (uid == null) throw Exception('User is not login yet');
  final Client client = Client();
  return RepoCandidate(client: client, uid: uid);
});

abstract class IRepoCandidate {
  Future<List<ModelCandidate>> finds();
  Future<ModelCandidate> find(String id);
  Future<void> update(ModelCandidate candidate);
  Future<void> tes(String req);
}

class RepoCandidate implements IRepoCandidate {
  final String uid;
  final Client client;
  RepoCandidate({required this.client, required this.uid});

  @override
  Future<ModelCandidate> find(String id) {
    // TODO: implement find
    throw UnimplementedError();
  }

  @override
  Future<List<ModelCandidate>> finds() async {
    throw UnimplementedError();
  }

  @override
  Future<void> update(ModelCandidate candidate) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<void> tes(String req) async {
    try {
      final result = await client.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=AIzaSyAkdXrrOZNHWcARmG6Bm3JbacdbZluIOn4',
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "role": "user",
              "parts": [
                {"text": req},
              ],
            },
          ],
        }),
      );
      print(result.body);
      return;
    } catch (e) {
      rethrow;
    }
  }
}
