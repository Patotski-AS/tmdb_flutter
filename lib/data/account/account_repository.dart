import 'package:tmdb_flutter/core/network/tmdb_exception.dart';
import 'package:tmdb_flutter/data/account/account_exception.dart';
import 'package:tmdb_flutter/data/tmdb/model/movie.dart';

/// Favorite movies for the signed-in TMDB account.
///
/// A guest fails with [AccountAuthorizationException] before any HTTP
/// call. Other failures are thrown as [TmdbException]. HTTP 401 logs out.
abstract interface class AccountRepository {
  /// Whether [movieId] is on the account favorite list.
  Future<bool> isFavorite(int movieId);

  /// Adds or removes [movieId].
  ///
  /// The caller keeps its previous flag when this call throws.
  Future<void> setFavorite({required int movieId, required bool favorite});

  /// Every page of favorite movies, with poster URLs filled in.
  Future<List<Movie>> getFavoriteMovies();
}
