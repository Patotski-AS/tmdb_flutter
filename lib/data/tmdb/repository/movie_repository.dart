import 'package:tmdb_flutter/core/network/tmdb_exception.dart';
import 'package:tmdb_flutter/data/tmdb/model/genre.dart';
import 'package:tmdb_flutter/data/tmdb/model/image_configuration.dart';
import 'package:tmdb_flutter/data/tmdb/model/movie.dart';
import 'package:tmdb_flutter/data/tmdb/model/movie_details.dart';
import 'package:tmdb_flutter/data/tmdb/model/paged.dart';

/// Movies, movie genres, movie details, and image configuration.
///
/// Failures are thrown as [TmdbException].
abstract interface class MovieRepository {
  /// Movie genres in Russian.
  Future<List<Genre>> getMovieGenres();

  /// Popular movies.
  ///
  /// [page] starts at 1.
  Future<Paged<Movie>> getPopularMovies([int page = 1]);

  /// Movies matching [query].
  ///
  /// [page] starts at 1.
  Future<Paged<Movie>> searchMovies(String query, [int page = 1]);

  /// Movies for the discover filters.
  ///
  /// Null [genreId] and [sortBy] are not sent. [page] starts at 1.
  Future<Paged<Movie>> discoverMovies({
    int? genreId,
    String? sortBy,
    int page = 1,
  });

  /// Movie card for [movieId], including credits and videos.
  Future<MovieDetails> getMovieDetails(int movieId);

  /// Cached TMDB image configuration.
  Future<ImageConfiguration> getImageConfiguration();
}
