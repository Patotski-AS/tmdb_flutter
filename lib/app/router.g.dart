// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$catalogRoute];

RouteBase get $catalogRoute => GoRouteData.$route(
  path: '/',
  hasOverriddenOnExit: false,
  factory: $CatalogRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'profile',
      hasOverriddenOnExit: false,
      factory: $ProfileRoute._fromState,
      routes: [
        GoRouteData.$route(
          path: 'favorites',
          hasOverriddenOnExit: false,
          factory: $FavoritesRoute._fromState,
        ),
      ],
    ),
    GoRouteData.$route(
      path: 'movie/:id',
      hasOverriddenOnExit: false,
      factory: $MovieRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'tv/:id',
      hasOverriddenOnExit: false,
      factory: $TvRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'person/:id',
      hasOverriddenOnExit: false,
      factory: $PersonRoute._fromState,
    ),
  ],
);

mixin $CatalogRoute on GoRouteData {
  static CatalogRoute _fromState(GoRouterState state) => const CatalogRoute();

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

mixin $ProfileRoute on GoRouteData {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  @override
  String get location => GoRouteData.$location('/profile');

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

mixin $FavoritesRoute on GoRouteData {
  static FavoritesRoute _fromState(GoRouterState state) =>
      const FavoritesRoute();

  @override
  String get location => GoRouteData.$location('/profile/favorites');

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

mixin $MovieRoute on GoRouteData {
  static MovieRoute _fromState(GoRouterState state) =>
      MovieRoute(id: state.pathParameters['id']!);

  MovieRoute get _self => this as MovieRoute;

  @override
  String get location =>
      GoRouteData.$location('/movie/${Uri.encodeComponent(_self.id)}');

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

mixin $TvRoute on GoRouteData {
  static TvRoute _fromState(GoRouterState state) =>
      TvRoute(id: state.pathParameters['id']!);

  TvRoute get _self => this as TvRoute;

  @override
  String get location =>
      GoRouteData.$location('/tv/${Uri.encodeComponent(_self.id)}');

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

mixin $PersonRoute on GoRouteData {
  static PersonRoute _fromState(GoRouterState state) =>
      PersonRoute(id: state.pathParameters['id']!);

  PersonRoute get _self => this as PersonRoute;

  @override
  String get location =>
      GoRouteData.$location('/person/${Uri.encodeComponent(_self.id)}');

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

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Typed [GoRouter] for the application shell.

@ProviderFor(router)
final routerProvider = RouterProvider._();

/// Typed [GoRouter] for the application shell.

final class RouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// Typed [GoRouter] for the application shell.
  RouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routerHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return router(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$routerHash() => r'3cf3f82f7aa0eeabb10d3002cff2a76ed42ba48b';
