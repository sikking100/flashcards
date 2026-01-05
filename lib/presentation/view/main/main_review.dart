import 'package:flashcards/data/models/model_review.dart';
import 'package:flashcards/presentation/model_view/mv_review_pagination.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class MainReview extends ConsumerWidget {
  const MainReview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reviewStateNotifierProvider);
    final vm = ref.read(reviewStateNotifierProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text('Reviews'), automaticallyImplyLeading: false),
      body: RefreshIndicator(
        child: PagedListView.separated(
          padding: EdgeInsets.all(16).copyWith(top: 0),
          state: state,
          fetchNextPage: () => vm.fetchNextPage(),
          builderDelegate: PagedChildBuilderDelegate<ModelReview>(
            itemBuilder: (context, item, index) => Card(
              child: ListTile(title: Text(item.front), subtitle: Text(item.back), trailing: Text('Not Know : ${item.reviewCount}')),
            ),
          ),
          separatorBuilder: (context, index) => SizedBox(),
        ),
        onRefresh: () => vm.refresh(),
      ),
    );
  }
}
