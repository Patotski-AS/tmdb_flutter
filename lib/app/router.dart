import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tmdb_flutter/app/placeholder_page.dart';

part 'router.g.dart';

/// Catalog at `/`.
@TypedGoRoute<CatalogRoute>(
  path: '/',
  routes: [
    TypedGoRoute<ProfileRoute>(
      path: 'profile',
      routes: [
        TypedGoRoute<FavoritesRoute>(path: 'favorites'),
      ],
    ),
    TypedGoRoute<MovieRoute>(path: 'movie/:id'),
    TypedGoRoute<TvRoute>(path: 'tv/:id'),
    TypedGoRoute<PersonRoute>(path: 'person/:id'),
  ],
)
class CatalogRoute extends GoRouteData with $CatalogRoute {
  /// Creates the catalog route.
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PlaceholderPage(title: 'Каталог');
  }
}

/// Profile at `/profile`.
class ProfileRoute extends GoRouteData with $ProfileRoute {
  /// Creates the profile route.
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PlaceholderPage(title: 'Профиль');
  }
}

/// Favorites at `/profile/favorites`.
class FavoritesRoute extends GoRouteData with $FavoritesRoute {
  /// Creates the favorites route.
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PlaceholderPage(title: 'Избранное');
  }
}

/// Movie details at `/movie/:id`.
class MovieRoute extends GoRouteData with $MovieRoute {
  /// Creates a movie route for [id].
  const new({required this.id});

  /// Movie id from the path.
  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PlaceholderPage(title: 'Фильм', id: id);
  }
}

/// TV details at `/tv/:id`.
class TvRoute extends GoRouteData with $TvRoute {
  /// Creates a TV route for [id].
  const new({required this.id});

  /// TV show id from the path.
  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PlaceholderPage(title: 'Сериал', id: id);
  }
}

/// Person details at `/person/:id`.
class PersonRoute extends GoRouteData with $PersonRoute {
  /// Creates a person route for [id].
  const new({required this.id});

  /// Person id from the path.
  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PlaceholderPage(title: 'Персона', id: id);
  }
}

/// Typed [GoRouter] for the application shell.
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final goRouter = GoRouter(routes: $appRoutes);
  ref.onDispose(goRouter.dispose);
  return goRouter;
}
