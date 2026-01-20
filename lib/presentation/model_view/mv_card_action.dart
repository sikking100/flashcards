import 'package:flashcards/data/models/model_card.dart';
import 'package:flashcards/data/repository/repo_review.dart';
import 'package:flashcards/presentation/model_view/mv_cards_pagination.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flashcards/data/repository/repo_card.dart';

final cardActionProvider = Provider<CardAction>((ref) {
  return CardAction(ref: ref);
});

class CardAction {
  final Ref ref;
  CardAction({required this.ref});

  Future<void> create({required String idDeck, required String front, required String back}) async {
    await ref.read(repoCardProvider).create(idDeck: idDeck, front: front, back: back);
    ref.read(cardStateNotifierProvider(idDeck).notifier).refresh();
    return;
  }

  Future<void> delete({required String idDeck, required String id}) async {
    await ref.read(repoCardProvider).delete(idDeck: idDeck, id: id);
    await ref.read(repoReviewProvider).delete(id: id);
    ref.read(cardStateNotifierProvider(idDeck).notifier).refresh();
  }

  Future<void> bulking({required String idDeck, required List<ModelCard> list}) async {
    final l = list;
    l.removeWhere((element) => element.front.isEmpty || element.back.isEmpty);
    await ref.read(repoCardProvider).bulk(idDeck: idDeck, list: l);
    ref.read(cardStateNotifierProvider(idDeck).notifier).refresh();
  }

  Future<void> update({required String idDeck, required String id, required String front, required String back}) async {
    await ref
        .read(repoCardProvider)
        .update(
          idDeck: idDeck,
          card: ModelCard(id: id, front: front, back: back, updatedAt: DateTime.now().millisecondsSinceEpoch),
        );
    await ref.read(repoReviewProvider).update(id: id, front: front, back: back);
    ref.read(cardStateNotifierProvider(idDeck).notifier).refresh();
  }
}
