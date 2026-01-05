import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flashcards/data/models/model_card.dart';
import 'package:flashcards/data/repository/repo_card.dart';

final cardStateNotifierProvider = NotifierProvider.family<CardPaginationNotifier, PagingState<DocumentSnapshot, ModelCard>, String>(
  CardPaginationNotifier.new,
);

class CardPaginationNotifier extends Notifier<PagingState<DocumentSnapshot, ModelCard>> {
  final String idDeck;
  CardPaginationNotifier(this.idDeck);
  @override
  PagingState<DocumentSnapshot, ModelCard> build() {
    state = PagingState();
    refresh();
    return state;
  }

  Future<void> refresh() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await ref.read(repoCardProvider).finds(idDeck: idDeck);
      if (result.docs.isEmpty) {
        state = state.copyWith(pages: [], hasNextPage: false, isLoading: false, keys: []);
        return;
      }
      final res = result.docs.map((e) => ModelCard.fromMap(e.data(), e.id)).toList();
      state = state.copyWith(pages: [res], hasNextPage: (result.docs.length) == 10, isLoading: false, keys: [result.docs.last]);
    } catch (e) {
      state = state.copyWith(error: e, isLoading: false);
    }
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading || !state.hasNextPage) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final pageKey = state.keys?.last as DocumentSnapshot<Map<String, dynamic>>;
      final result = await ref.read(repoCardProvider).finds(idDeck: idDeck, lastDoc: pageKey);
      if (result.docs.isEmpty) {
        state = state.copyWith(hasNextPage: false, isLoading: false);
        return;
      }
      final res = result.docs.map((e) => ModelCard.fromMap(e.data(), e.id)).toList();

      state = state.copyWith(
        pages: [...?state.pages, res],
        keys: [...?state.keys, pageKey],
        hasNextPage: (result.docs.length) == 10,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e, isLoading: false);
    }
  }
}
