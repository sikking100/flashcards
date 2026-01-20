// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $mainScreenRoute,
  $reviewScreenRoute,
  $studyScreenRoute,
  $cardDetailScreenRoute,
  $cardCreateScreenRoute,
  $deckDetailScreenRoute,
  $cardBulkScreenRoute,
  $candidateScreenRoute,
  $testScreenRoute,
];

RouteBase get $mainScreenRoute => ShellRouteData.$route(
  factory: $MainScreenRouteExtension._fromState,
  routes: [
    GoRouteData.$route(path: '/', factory: _$HomeRoute._fromState),
    GoRouteData.$route(path: '/reviews', factory: _$ReviewRoute._fromState),
    GoRouteData.$route(path: '/decks', factory: _$DeckRoute._fromState),
    GoRouteData.$route(path: '/settings', factory: _$SettingRoute._fromState),
  ],
);

extension $MainScreenRouteExtension on MainScreenRoute {
  static MainScreenRoute _fromState(GoRouterState state) => MainScreenRoute();
}

mixin _$HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => HomeRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin _$ReviewRoute on GoRouteData {
  static ReviewRoute _fromState(GoRouterState state) => ReviewRoute();

  @override
  String get location => GoRouteData.$location('/reviews');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin _$DeckRoute on GoRouteData {
  static DeckRoute _fromState(GoRouterState state) => DeckRoute();

  @override
  String get location => GoRouteData.$location('/decks');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin _$SettingRoute on GoRouteData {
  static SettingRoute _fromState(GoRouterState state) => SettingRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $reviewScreenRoute => GoRouteData.$route(
  path: '/review',
  factory: _$ReviewScreenRoute._fromState,
);

mixin _$ReviewScreenRoute on GoRouteData {
  static ReviewScreenRoute _fromState(GoRouterState state) =>
      ReviewScreenRoute($extra: state.extra as List<ModelReview>);

  ReviewScreenRoute get _self => this as ReviewScreenRoute;

  @override
  String get location => GoRouteData.$location('/review');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $studyScreenRoute =>
    GoRouteData.$route(path: '/study', factory: _$StudyScreenRoute._fromState);

mixin _$StudyScreenRoute on GoRouteData {
  static StudyScreenRoute _fromState(GoRouterState state) => StudyScreenRoute(
    idDeck: state.uri.queryParameters['id-deck']!,
    title: state.uri.queryParameters['title']!,
  );

  StudyScreenRoute get _self => this as StudyScreenRoute;

  @override
  String get location => GoRouteData.$location(
    '/study',
    queryParams: {'id-deck': _self.idDeck, 'title': _self.title},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $cardDetailScreenRoute => GoRouteData.$route(
  path: '/card-detail',
  factory: _$CardDetailScreenRoute._fromState,
);

mixin _$CardDetailScreenRoute on GoRouteData {
  static CardDetailScreenRoute _fromState(GoRouterState state) =>
      CardDetailScreenRoute();

  @override
  String get location => GoRouteData.$location('/card-detail');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $cardCreateScreenRoute => GoRouteData.$route(
  path: '/create',
  factory: _$CardCreateScreenRoute._fromState,
);

mixin _$CardCreateScreenRoute on GoRouteData {
  static CardCreateScreenRoute _fromState(GoRouterState state) =>
      CardCreateScreenRoute();

  @override
  String get location => GoRouteData.$location('/create');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $deckDetailScreenRoute => GoRouteData.$route(
  path: '/detail',
  factory: _$DeckDetailScreenRoute._fromState,
);

mixin _$DeckDetailScreenRoute on GoRouteData {
  static DeckDetailScreenRoute _fromState(GoRouterState state) =>
      DeckDetailScreenRoute(
        id: state.uri.queryParameters['id']!,
        name: state.uri.queryParameters['name']!,
      );

  DeckDetailScreenRoute get _self => this as DeckDetailScreenRoute;

  @override
  String get location => GoRouteData.$location(
    '/detail',
    queryParams: {'id': _self.id, 'name': _self.name},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $cardBulkScreenRoute => GoRouteData.$route(
  path: '/bulk',
  factory: _$CardBulkScreenRoute._fromState,
);

mixin _$CardBulkScreenRoute on GoRouteData {
  static CardBulkScreenRoute _fromState(GoRouterState state) =>
      CardBulkScreenRoute(idDeck: state.uri.queryParameters['id-deck']!);

  CardBulkScreenRoute get _self => this as CardBulkScreenRoute;

  @override
  String get location =>
      GoRouteData.$location('/bulk', queryParams: {'id-deck': _self.idDeck});

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $candidateScreenRoute => GoRouteData.$route(
  path: '/candidate',
  factory: _$CandidateScreenRoute._fromState,
);

mixin _$CandidateScreenRoute on GoRouteData {
  static CandidateScreenRoute _fromState(GoRouterState state) =>
      CandidateScreenRoute($extra: state.extra as File);

  CandidateScreenRoute get _self => this as CandidateScreenRoute;

  @override
  String get location => GoRouteData.$location('/candidate');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $testScreenRoute =>
    GoRouteData.$route(path: '/test', factory: _$TestScreenRoute._fromState);

mixin _$TestScreenRoute on GoRouteData {
  static TestScreenRoute _fromState(GoRouterState state) => TestScreenRoute();

  @override
  String get location => GoRouteData.$location('/test');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
