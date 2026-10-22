import 'package:tmdb_flutter/data/tmdb/dto/movie_dto.dart';

/// Account endpoints of TMDB API v3.
///
/// Each request opts in to the stored session id. Catalog calls stay
/// on the catalog client. Favorite lists use `language=ru-RU`.
abstract interface class AccountApi {
  /// `GET movie/{movieId}/account_states`.
  ///
  /// Returns the `favorite` field.
  Future<bool> isFavorite({required int movieId});

  /// `POST account/{accountId}/favorite`.
  ///
  /// The body is `media_type=movie`, [movieId] and [favorite].
  Future<void> setFavorite({
    required int accountId,
    required int movieId,
    required bool favorite,
  });

  /// `GET account/{accountId}/favorite/movies` for one [page].
  Future<PopularMoviesResponseDto> getFavoriteMovies({
    required int accountId,
    required int page,
  });
}
