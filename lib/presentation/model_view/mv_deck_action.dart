import 'package:flashcards/data/repository/repo_deck.dart';
import 'package:flashcards/presentation/model_view/mv_deck_pagination.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deckActionProvider = Provider<MvDeckAction>((ref) {
  return MvDeckAction(ref: ref);
});

class MvDeckAction {
  final Ref ref;
  MvDeckAction({required this.ref});

  Future<void> create(String title) async {
    await ref.read(repoDeckProvider).create(title);
    ref.read(deckStateNotifierProvider.notifier).refresh();
  }

  Future<void> delete(String id) async {
    await ref.read(repoDeckProvider).delete(id);
    ref.read(deckStateNotifierProvider.notifier).refresh();
  }

  Future<void> update(String id, String title) async {
    await ref.read(repoDeckProvider).update(id, title);
    ref.read(deckStateNotifierProvider.notifier).refresh();
  }
}
