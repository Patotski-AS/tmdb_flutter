import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tmdb_flutter/feature/details/details_page.dart';
import 'package:tmdb_flutter/feature/details/details_state.dart';
import 'package:tmdb_flutter/feature/media/media_page.dart';
import 'package:tmdb_flutter/feature/person/person_page.dart';
import 'package:tmdb_flutter/feature/profile/favorites_page.dart';
import 'package:tmdb_flutter/feature/profile/profile_page.dart';

part 'router.g.dart';

/// Catalog at `/`.
@TypedGoRoute<CatalogRoute>(
  path: '/',
  routes: [
    TypedGoRoute<ProfileRoute>(
      path: 'profile',
      routes: [TypedGoRoute<FavoritesRoute>(path: 'favorites')],
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
    return const MediaPage();
  }
}

/// Profile at `/profile`.
class ProfileRoute extends GoRouteData with $ProfileRoute {
  /// Creates the profile route.
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProfilePage();
  }
}

/// Favorites at `/profile/favorites`.
class FavoritesRoute extends GoRouteData with $FavoritesRoute {
  /// Creates the favorites route.
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FavoritesPage();
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
    final movieId = int.tryParse(id);
    if (movieId == null) {
      return const DetailsInvalidIdPage();
    }
    return DetailsPage(mediaType: DetailsMediaType.movie, id: movieId);
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
    final tvId = int.tryParse(id);
    if (tvId == null) {
      return const DetailsInvalidIdPage();
    }
    return DetailsPage(mediaType: DetailsMediaType.tv, id: tvId);
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
    final personId = int.tryParse(id);
    if (personId == null) {
      return const DetailsInvalidIdPage();
    }
    return PersonPage(id: personId);
  }
}

/// Typed [GoRouter] for the application shell.
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final goRouter = GoRouter(routes: $appRoutes);
  ref.onDispose(goRouter.dispose);
  return goRouter;
}
