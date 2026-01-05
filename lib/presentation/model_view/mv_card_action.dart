import 'package:flashcards/data/models/model_card.dart';
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
    ref.read(repoCardProvider).create(idDeck: idDeck, front: front, back: back);
    ref.read(cardStateNotifierProvider(idDeck).notifier).refresh();
    return;
  }

  Future<void> delete({required String idDeck, required String id}) async {
    ref.read(repoCardProvider).delete(idDeck: idDeck, id: id);
    ref.read(cardStateNotifierProvider(idDeck).notifier).refresh();
  }

  Future<void> bulking({required String idDeck, required List<ModelCard> list}) async {
    ref.read(repoCardProvider).bulk(idDeck: idDeck, list: list);
    ref.read(cardStateNotifierProvider(idDeck).notifier).refresh();
  }
}
