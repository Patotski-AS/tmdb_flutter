import 'package:tmdb_flutter/core/network/tmdb_exception.dart';
import 'package:tmdb_flutter/data/tmdb/model/genre.dart';
import 'package:tmdb_flutter/data/tmdb/model/paged.dart';
import 'package:tmdb_flutter/data/tmdb/model/tv_show.dart';
import 'package:tmdb_flutter/data/tmdb/model/tv_show_details.dart';

/// TV shows, TV genres, and TV details.
///
/// Failures are thrown as [TmdbException].
abstract interface class TvRepository {
  /// TV genres in Russian.
  Future<List<Genre>> getTvGenres();

  /// Popular TV shows.
  ///
  /// [page] starts at 1.
  Future<Paged<TvShow>> getPopularTvShows([int page = 1]);

  /// Shows matching [query].
  ///
  /// [page] starts at 1.
  Future<Paged<TvShow>> searchTvShows(String query, [int page = 1]);

  /// Shows for the discover filters.
  ///
  /// Null [genreId] and [sortBy] are not sent. [page] starts at 1.
  Future<Paged<TvShow>> discoverTvShows({
    int? genreId,
    String? sortBy,
    int page = 1,
  });

  /// TV card for [tvId], including credits and videos.
  Future<TvShowDetails> getTvShowDetails(int tvId);
}
