import 'package:flashcards/presentation/model_view/mv_home.dart';
import 'package:flashcards/router.dart';
import 'package:flashcards/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainHome extends ConsumerWidget {
  const MainHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(todayStudyProvider);
    return Padding(
      padding: EdgeInsets.all(16),
      child: state.when(
        data: (data) {
          if (data.isEmpty) return Center(child: Text('You don’t have any cards yet. Create your first deck.'));
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('You have ${data.length} cards to study today'),
                FilledButton(
                  onPressed: () async {
                    final result = await StudyScreenRoute($extra: data).push(context);
                    if (result != null) ref.invalidate(todayStudyProvider);
                  },
                  child: Text('Start Learning'),
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) => Center(child: Text('$error')),
        loading: () => Center(child: WidgetLoading()),
      ),
    );
  }
}
