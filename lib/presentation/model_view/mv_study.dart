import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcards/data/models/model_card.dart';
import 'package:flashcards/data/repository/repo_card.dart';
import 'package:flashcards/data/repository/repo_deck.dart';
import 'package:flashcards/data/repository/repo_review.dart';
import 'package:flashcards/widgets/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mvStudyProvider = Provider<MvStudy>((ref) {
  return MvStudy(ref: ref);
});

class MvStudy {
  final Ref ref;
  MvStudy({required this.ref});
  Future<void> swipe({required String id, required String direction}) {
    return ref.read(repoReviewProvider).swipe(id: id, direction: direction);
  }

  Future<void> notknow({required String id}) {
    return ref.read(repoReviewProvider).notknow(id: id);
  }
}

class StudyPrompt {
  final String question;
  final String correctAnswer;
  final List<String>? choices;

  StudyPrompt({required this.question, required this.correctAnswer, this.choices}); // only for MC
}

StudyPrompt buildPrompt(ModelCard card, StudyMode mode, List<ModelCard> deckCards) {
  switch (mode) {
    case StudyMode.frontToBack:
      return StudyPrompt(question: card.front, correctAnswer: card.back);

    case StudyMode.backToFront:
      return StudyPrompt(question: card.back, correctAnswer: card.front);

    case StudyMode.multipleChoice:
      final distractors = deckCards.where((c) => c.id != card.id).take(3).map((c) => c.back).toList();

      return StudyPrompt(question: card.front, correctAnswer: card.back, choices: ([card.back, ...distractors]..shuffle()));

    case StudyMode.typing:
      return StudyPrompt(question: card.front, correctAnswer: card.back);
  }
}

final studyNotifierProvider = NotifierProvider.family.autoDispose<StudyNotifier, AsyncValue<List<ModelCard>>, String>(StudyNotifier.new);

class StudyNotifier extends Notifier<AsyncValue<List<ModelCard>>> {
  late final StudyMode mode;
  final String idDeck;
  late DocumentSnapshot<Object?>? lastDoc;
  StudyNotifier(this.idDeck);

  @override
  AsyncValue<List<ModelCard>> build() {
    mode = StudyMode.values[2];
    init();
    return AsyncValue.loading();
  }

  void init() async {
    try {
      state = await AsyncValue.guard(() async {
        final cards = await ref.read(repoCardProvider).finds(idDeck: idDeck);
        lastDoc = cards.docs.isNotEmpty ? cards.docs.last : null;
        final result = cards.docs.map((e) => ModelCard.fromMap(e.data(), e.id)).toList();
        return result;
      });
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  void next() async {
    try {
      if (lastDoc == null) {
        state = AsyncValue.data([]);
        return;
      }
      state = await AsyncValue.guard(() async {
        final cards = await ref.read(repoCardProvider).finds(idDeck: idDeck, lastDoc: lastDoc);
        if (cards.docs.isEmpty) {
          lastDoc = null;
          return [];
        }
        lastDoc = cards.docs.isNotEmpty ? cards.docs.last : null;
        final result = cards.docs.map((e) => ModelCard.fromMap(e.data(), e.id)).toList();
        return result;
      });
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}
