import 'package:flashcards/presentation/model_view/mv_home.dart';
import 'package:flashcards/presentation/model_view/mv_main.dart';
import 'package:flashcards/presentation/model_view/mv_on_boarding.dart';
import 'package:flashcards/router.dart';
import 'package:flashcards/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PageMain extends ConsumerWidget {
  final Widget navigationShell;
  const PageMain({super.key, required this.navigationShell});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = ref.watch(mainViewNotifierProvider);
    if (future == VIEW.loading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (future == VIEW.error) {
      return Scaffold(body: Center(child: Text('An error occurred')));
    }
    if (future == VIEW.onBoarding) {
      return Onboard();
    }

    return MainShell(widget: navigationShell);
    // return future.when(
    //   data: (data) => MainShell(widget: navigationShell),
    //   error: (error, stackTrace) => Scaffold(body: Center(child: Text('$error'))),
    //   loading: () => Scaffold(body: Center(child: CircularProgressIndicator())),
    // );
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
          BottomNavigationBarItem(icon: Icon(Icons.deck), label: 'Decks'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class Onboard extends HookConsumerWidget {
  const Onboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = useState(0);
    final controller = usePageController();
    final loading = useState(false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Onboarding'),
        actions: [TextButton(onPressed: () {}, child: Text('Button'))],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: controller,
              onPageChanged: (value) => index.value = value,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Placeholder(fallbackHeight: 200),
                      SizedBox(height: 16),
                      Text('Welcome to Flashcards!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('This is an app to help you study with flashcards. Let\'s get started!', textAlign: TextAlign.center),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Placeholder(fallbackHeight: 200),
                      SizedBox(height: 16),
                      Text('Welcome to Flashcards!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('This is an app to help you study with flashcards. Let\'s get started!', textAlign: TextAlign.center),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Placeholder(fallbackHeight: 200),
                      SizedBox(height: 16),
                      Text('Welcome to Flashcards!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('This is an app to help you study with flashcards. Let\'s get started!', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              return Container(
                margin: EdgeInsets.all(4.0),
                width: 12,
                height: 12,
                decoration: BoxDecoration(shape: BoxShape.circle, color: index.value == i ? Colors.cyan : Colors.grey),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: FilledButton(
          onPressed: loading.value
              ? null
              : () async {
                  if (index.value < 2) {
                    index.value += 1;
                    controller.animateToPage(index.value, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                  } else {
                    try {
                      loading.value = true;
                      await ref.read(mvMainBoardingActionProvider).completeOnBoarding();
                      ref.invalidate(mainViewNotifierProvider);
                      return;
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error completing onboarding: $e')));
                    } finally {
                      loading.value = false;
                    }
                  }
                },
          child: loading.value ? WidgetLoading() : Text(index.value < 2 ? 'Next' : 'Get Started'),
        ),
      ),
    );
  }
}
