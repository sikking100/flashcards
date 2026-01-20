import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcards/data/models/model_deck.dart';
import 'package:flashcards/data/repository/repo_deck.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:simple_logger/simple_logger.dart';

final deckStateNotifierProvider = NotifierProvider<DeckPaginationNotifier, PagingState<DocumentSnapshot, ModelDeck>>(DeckPaginationNotifier.new);

class DeckPaginationNotifier extends Notifier<PagingState<DocumentSnapshot, ModelDeck>> {
  @override
  PagingState<DocumentSnapshot, ModelDeck> build() {
    state = PagingState();
    refresh();
    return state;
  }

  Future<void> refresh() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await ref.read(repoDeckProvider).finds();
      if (result.docs.isEmpty) {
        state = state.copyWith(pages: [], hasNextPage: false, isLoading: false, keys: []);
        return;
      }
      final res = result.docs.map((e) => ModelDeck.fromMap(e.data(), e.id)).toList();
      state = state.copyWith(pages: [res], hasNextPage: (result.docs.length) == 10, isLoading: false, keys: [result.docs.last]);
    } catch (e) {
      SimpleLogger().info(e);
      state = state.copyWith(error: e, isLoading: false);
    }
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading || !state.hasNextPage) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final pageKey = state.keys?.last as DocumentSnapshot<Map<String, dynamic>>;
      final result = await ref.read(repoDeckProvider).finds(pageKey);
      final res = result.docs.map((e) => ModelDeck.fromMap(e.data(), e.id)).toList();

      state = state.copyWith(
        pages: [...?state.pages, res],
        keys: [...?state.keys, result.docs.last],
        hasNextPage: (result.docs.length) == 10,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e, isLoading: false);
    }
  }
}
