// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flashcards/presentation/view/page_candidates.dart';
import 'package:flashcards/presentation/view/page_study.dart';
import 'package:flashcards/presentation/view/page_test.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flashcards/data/models/model_review.dart';
import 'package:flashcards/presentation/view/main/main_deck.dart';
import 'package:flashcards/presentation/view/main/main_home.dart';
import 'package:flashcards/presentation/view/main/main_review.dart';
import 'package:flashcards/presentation/view/main/main_settings.dart';
import 'package:flashcards/presentation/view/page_card_bulking.dart';
import 'package:flashcards/presentation/view/page_card_create.dart';
import 'package:flashcards/presentation/view/page_card_detail.dart';
import 'package:flashcards/presentation/view/page_deck_detail.dart';
import 'package:flashcards/presentation/view/page_main.dart';
import 'package:flashcards/presentation/view/page_review.dart';

part "router.g.dart";

final mainRouter = GoRouter(routes: $appRoutes);

final mainRouteProvider = Provider<GoRouter>((_) => mainRouter);

@TypedShellRoute<MainScreenRoute>(
  routes: [
    TypedGoRoute<HomeRoute>(path: '/'),
    TypedGoRoute<ReviewRoute>(path: '/reviews'),
    TypedGoRoute<DeckRoute>(path: '/decks'),
    TypedGoRoute<SettingRoute>(path: '/settings'),
  ],
)
class MainScreenRoute extends ShellRouteData {
  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return PageMain(navigationShell: navigator);
  }
}

class HomeRoute extends GoRouteData with _$HomeRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MainHome();
  }
}

class ReviewRoute extends GoRouteData with _$ReviewRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MainReview();
  }
}

class DeckRoute extends GoRouteData with _$DeckRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MainDeck();
  }
}

class SettingRoute extends GoRouteData with _$SettingRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MainSettings();
  }
}

@TypedGoRoute<ReviewScreenRoute>(path: '/review')
class ReviewScreenRoute extends GoRouteData with _$ReviewScreenRoute {
  final List<ModelReview> $extra;
  ReviewScreenRoute({required this.$extra});
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PageReview(list: $extra);
  }
}

@TypedGoRoute<StudyScreenRoute>(path: '/study')
class StudyScreenRoute extends GoRouteData with _$StudyScreenRoute {
  final String idDeck;
  final String title;
  StudyScreenRoute({required this.idDeck, required this.title});
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PageStudy(idDeck: idDeck, title: title);
  }
}

// class AuthScreenRoute extends GoRouteData with _$AuthScreenRoute {
//   @override
//   Widget build(BuildContext context, GoRouterState state) {
//     return PageAuth();
//   }
// }

@TypedGoRoute<CardDetailScreenRoute>(path: '/card-detail')
class CardDetailScreenRoute extends GoRouteData with _$CardDetailScreenRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PageCardDetail();
  }
}

@TypedGoRoute<CardCreateScreenRoute>(path: '/create')
class CardCreateScreenRoute extends GoRouteData with _$CardCreateScreenRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PageCardCreate();
  }
}

@TypedGoRoute<DeckDetailScreenRoute>(path: '/detail')
class DeckDetailScreenRoute extends GoRouteData with _$DeckDetailScreenRoute {
  final String id;
  final String name;
  DeckDetailScreenRoute({required this.id, required this.name});
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PageDeckDetail(id: id, name: name);
  }
}

@TypedGoRoute<CardBulkScreenRoute>(path: '/bulk')
class CardBulkScreenRoute extends GoRouteData with _$CardBulkScreenRoute {
  final String idDeck;
  CardBulkScreenRoute({required this.idDeck});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PageCardBulking(idDeck: idDeck);
  }
}

@TypedGoRoute<CandidateScreenRoute>(path: '/candidate')
class CandidateScreenRoute extends GoRouteData with _$CandidateScreenRoute {
  final File $extra;
  CandidateScreenRoute({required this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PageCandidates(file: $extra);
  }
}

@TypedGoRoute<TestScreenRoute>(path: '/test')
class TestScreenRoute extends GoRouteData with _$TestScreenRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PageTest();
  }
}
