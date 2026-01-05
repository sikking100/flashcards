// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flashcards/presentation/view/page_candidates.dart';
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
import 'package:flashcards/presentation/view/page_study.dart';

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

@TypedGoRoute<StudyScreenRoute>(path: '/study')
class StudyScreenRoute extends GoRouteData with _$StudyScreenRoute {
  final List<ModelReview> $extra;
  StudyScreenRoute({required this.$extra});
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PageStudy(list: $extra);
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
