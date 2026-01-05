import 'package:flashcards/presentation/model_view/mv_home.dart';
import 'package:flashcards/presentation/model_view/mv_main.dart';
import 'package:flashcards/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PageMain extends ConsumerWidget {
  final Widget navigationShell;
  const PageMain({super.key, required this.navigationShell});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = ref.watch(mainProvider);
    return future.when(
      data: (data) => MainShell(widget: navigationShell),
      error: (error, stackTrace) => Scaffold(body: Center(child: Text('$error'))),
      loading: () => Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}

class MainShell extends ConsumerWidget {
  final Widget widget;
  const MainShell({super.key, required this.widget});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();

    final currentIndex = switch (location) {
      '/' => 0,
      '/reviews' => 1,
      '/decks' => 2,
      '/settings' => 3,
      _ => 0,
    };

    return Scaffold(
      body: widget,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) => switch (value) {
          0 => {ref.invalidate(todayStudyProvider), HomeRoute().push(context)},
          1 => ReviewRoute().push(context),
          2 => DeckRoute().push(context),
          _ => SettingRoute().push(context),
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.reviews), label: 'Review'),
          BottomNavigationBarItem(icon: Icon(Icons.deck), label: 'Deck'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
