import 'package:firebase_core/firebase_core.dart';
import 'package:flashcards/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(mainRouteProvider);
    return MaterialApp.router(
      routerConfig: router,
      title: 'Flashcards',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.cyan,
          type: BottomNavigationBarType.fixed,
        ),
        listTileTheme: ListTileThemeData(contentPadding: EdgeInsets.only(right: 8, left: 16)),
      ),
    );
  }
}
