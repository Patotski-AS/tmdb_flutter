import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tmdb_flutter/core/network/tmdb_exception.dart';
import 'package:tmdb_flutter/data/account/account_exception.dart';
import 'package:tmdb_flutter/data/account/account_providers.dart';
import 'package:tmdb_flutter/data/session/session_repository.dart';
import 'package:tmdb_flutter/data/session/session_state.dart';
import 'package:tmdb_flutter/feature/profile/favorites_state.dart';

part 'favorites_notifier.g.dart';

/// Favorite movies for the signed-in account.
///
/// A guest stays empty and does not call the account API.
/// Logout clears the list.
@riverpod
class FavoritesNotifier extends _$FavoritesNotifier {
  var _generation = 0;

  @override
  FavoritesState build() {
    ref.listen(sessionRepositoryProvider, (previous, next) {
      final value = next.asData?.value;
      if (value is Authenticated) {
        unawaited(refresh());
        return;
      }
      if (next.hasValue) {
        _generation += 1;
        state = const FavoritesState();
      }
    });

    final session = ref.read(sessionRepositoryProvider);
    if (session.isLoading) {
      return const FavoritesState(isLoading: true);
    }
    if (session.asData?.value is Authenticated) {
      unawaited(Future<void>.microtask(refresh));
      return const FavoritesState(isLoading: true);
    }
    return const FavoritesState();
  }

  /// Loads every favorite page.
  ///
  /// A guest returns without an account request.
  Future<void> refresh() async {
    if (!ref.mounted || !_signedIn()) {
      return;
    }
    final generation = ++_generation;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final movies = await ref
          .read(accountRepositoryProvider)
          .getFavoriteMovies();
      if (!ref.mounted || generation != _generation || !_signedIn()) {
        return;
      }
      state = FavoritesState(movies: movies);
    } on AccountAuthorizationException {
      if (!ref.mounted || generation != _generation) {
        return;
      }
      state = const FavoritesState();
    } on TmdbException catch (error) {
      if (!ref.mounted || generation != _generation || !_signedIn()) {
        return;
      }
      state = state.copyWith(isLoading: false, error: error.message);
    }
  }

  bool _signedIn() {
    final value = ref.read(sessionRepositoryProvider).asData?.value;
    return value is Authenticated;
  }
}
